import 'dart:convert';
import 'package:employeeattendance/DrawerPage/view_attendance.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:employeeattendance/model/calender_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  Future<CalenderModel> getData() async {
    final url = '${apiUrl}attendance?id=${GlobalVariable.uid}';
    var response = await http.post(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    return CalenderModel.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("Attendance", style: TextStyle(color: Colors.white)),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () => Get.to(const ViewAttendance()),
              icon: const Icon(Icons.calendar_month, color: Colors.white)),
        ],
      ),
      body: FutureBuilder<CalenderModel>(
          future: getData(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Expanded(
                  child: FutureBuilder<CalenderModel>(
                    future: getData(),
                    builder: ((context, snapshot) => snapshot.hasData
                        ? snapshot.data!.status == true
                            ? ListView.builder(
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: ((context, index) =>
                                    buildTile(snapshot, index)),
                              )
                            : const Center(child: Text("No data found..."))
                        : const Center(
                            child: CircularProgressIndicator(),
                          )),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Container buildTile(AsyncSnapshot<CalenderModel> snapshot, int index) {
    bool isPresent = snapshot.data!.data![index].workStatus == 'Present';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.black12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              snapshot.data!.data![index].date!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              snapshot.data!.data![index].day!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  snapshot.data!.data![index].checkin!,
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
                const Text("---"),
                Text(
                  snapshot.data!.data![index].checkout!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.greenAccent)),
              child: Text(
                "Working hour : ${snapshot.data!.data![index].workingHours}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 5),
            const Text('Check-In Location'),
            Text(
              snapshot.data!.data![index].checkinLocation!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigoAccent),
            ),
            const SizedBox(height: 5),
            const Text('Check-Out Location'),
            Text(
              snapshot.data!.data![index].checkoutLocation ?? '-----',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigoAccent),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Status : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                Text(
                  snapshot.data!.data![index].workStatus ?? 'Not Available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isPresent ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
