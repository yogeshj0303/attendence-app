import 'dart:async';
import 'dart:convert';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/controller/location.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:slide_to_act/slide_to_act.dart';
import '../controller/globalvariable.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Colors.blue;
  bool isCheckedOut = false;
  bool isDone = false;
  @override
  void initState() {
    const LocationPage();
    super.initState();
  }

  Future checkInTime(
      int id, String location, double latitude, double longitude) async {
    final url =
        '${apiUrl}checkin?id=$id&location=$location&userLatitude=$latitude&userLongitude=$longitude';
    try {
      var response = await http.post(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        if (data['status'] == true) {
          setState(() {
            GlobalVariable.checkIn = data['data']['checkin'];
            GlobalVariable.checkInStatus = 1;
            isDone = true;
          });
          Fluttertoast.showToast(msg: 'Check-In Successful');
        } else {
          Get.defaultDialog(
            title: 'Error Occured',
            middleText: data['data'],
            onCancel: () => Get.back(),
          );
          Fluttertoast.showToast(msg: data['data']);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future checkOutTime(
      int id, String location, double latitude, double longitude) async {
    final url =
        '${apiUrl}checkout?id=$id&location=$location&userLatitude=$latitude&userLongitude=$longitude';
    try {
      var response = await http.post(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        if (data['status'] == true) {
          setState(() {
            GlobalVariable.checkOut = data['data']['checkout'];
            GlobalVariable.checkOutStatus = 1;
            isDone = true;
          });
          Fluttertoast.showToast(msg: 'Check-Out Successful');
        } else {
          Get.defaultDialog(
            title: 'Error Occured',
            middleText: data['data'],
            onCancel: () => Get.back(),
          );
          Fluttertoast.showToast(msg: data['data']);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("Exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Check-In & Out",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 5),
                alignment: Alignment.center,
                child: Text(
                  "Today's Status",
                  style: TextStyle(
                    fontSize: screenWidth / 18,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
                width: 200,
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                ),
                // height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                GlobalVariable.checkIn,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: screenWidth / 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                GlobalVariable.checkOut,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: screenWidth / 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('hh:mm:ss a').format(DateTime.now()),
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }),
              GlobalVariable.checkOutStatus == 0
                  ? Container(
                      margin: const EdgeInsets.only(top: 1),
                      child: Builder(
                        builder: (context) {
                          return SlideAction(
                            text: GlobalVariable.checkInStatus == 0
                                ? "Slide to Check In"
                                : "Slide to Check Out",
                            submittedIcon: isDone
                                ? const Icon(Icons.done, color: Colors.blue)
                                : const Icon(Icons.done, color: Colors.red),
                            outerColor: Colors.blue[50],
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth / 20,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                            onSubmit: () {
                              int id = GlobalVariable.uid!;
                              if (GlobalVariable.checkInStatus == 0 &&
                                  GlobalVariable.location != '') {
                                checkInTime(
                                    id,
                                    GlobalVariable.location,
                                    GlobalVariable.latitude,
                                    GlobalVariable.longitude);
                              } else if (GlobalVariable.checkInStatus == 1 &&
                                  GlobalVariable.location != '') {
                                checkOutTime(
                                    id,
                                    GlobalVariable.location,
                                    GlobalVariable.latitude,
                                    GlobalVariable.longitude);
                              } else {
                                setState(() {
                                  isDone = false;
                                });
                                Fluttertoast.showToast(
                                    msg:
                                        'Please enable location to check-in or check-out');
                              }
                            },
                          );
                        },
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        "You have done for today, Good Bye!!!",
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 18,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 20,
                child: Text("Current Location : "),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                alignment: Alignment.center,
                height: 35,
                child: Column(
                  children: [
                    const LocationPage(),
                    Text(GlobalVariable.location),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
                width: 275,
                child: Divider(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
