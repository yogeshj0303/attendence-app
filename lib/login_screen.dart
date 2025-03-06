import 'dart:convert';
import 'package:employeeattendance/HomePage/home_screen.dart';
import 'package:employeeattendance/HomePage/main_screen.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/model/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'controller/globalvariable.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future getLogin(String empId, String password) async {
    final url = '${apiUrl}login?id=$empId&password=$password';
    var response = await http.post(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      if (data['status'] == true) {
        GlobalVariable.uid = data['data']['id'];
        GlobalVariable.checkInStatus = data['data']['checkin_status'];
        GlobalVariable.checkOutStatus = data['data']['checkout_status'];
        GlobalVariable.checkIn = data['data']['checkin_time'];
        GlobalVariable.checkOut = data['data']['checkout_time'];
        GlobalVariable.lastUsage = data['data']['last_uses'];
        GlobalVariable.name = data['data']['name'];
        GlobalVariable.designation = data['data']['designation'];
        GlobalVariable.number = data['data']['number'];
        GlobalVariable.email = data['data']['email'];
        GlobalVariable.image = data['data']['image'];
        GlobalVariable.department = data['data']['department'];
        GlobalVariable.empID = data['data']['empid'];
        GlobalVariable.permanentAdd = data['data']['permanent_add'];
        // GlobalVariable.currentAdd = data['data']['corres_add'];
        // GlobalVariable.emergencynumber = data['data']['parent_mobile'];
        // GlobalVariable.blood = data['data']['blood_group'];
        GlobalVariable.branch = data['data']['branch_allocated'];
        GlobalVariable.joiningDate = data['data']['date_of_join'];
        GlobalVariable.salary = data['data']['salary'];


        AuthLogin.login(empId, password);
        Fluttertoast.showToast(msg: 'Login Successful')
            .then((value) => Get.offAll(() => const MainScreen()));
      } else {
        Fluttertoast.showToast(msg: 'Invalid Employee ID or Password');
      }
    }
  }

  bool isAccepted = false;
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Colors.blue;
  TextEditingController empIdController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final Uri url = Uri.parse('http://pinghr.in/privacy-policy');
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 36,right: 6, left: 6),
              height: screenHeight / 4,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius:
                    const BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 20,
                bottom: screenHeight / 20,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: screenWidth / 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  wordSpacing: 2,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Employee ID",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: screenWidth / 24,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(2, 2),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: screenWidth / 15,
                          child: Icon(
                            Icons.person,
                            color: primary,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth / 12),
                            child: TextFormField(
                              enableSuggestions: false,
                              autocorrect: false,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Enter your Employee Id",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: screenHeight / 36),
                                border: InputBorder.none,
                              ),
                              controller: empIdController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 20),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: screenWidth / 24,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(2, 2),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: screenWidth / 15,
                          child: Icon(
                            Icons.security,
                            color: primary,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth / 12),
                            child: TextFormField(
                              enableSuggestions: false,
                              autocorrect: false,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Enter your Password",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: screenHeight / 36),
                                border: InputBorder.none,
                              ),
                              controller: passController,
                              obscureText: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(1),
                    value: isAccepted,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('I agree to HR Hub ', style: TextStyle(fontSize: 12),),
                        InkWell(
                          onTap: () {
                            launchUrl(url);
                          },
                          child: const Text(
                            'Terms and Condition',
                            style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Flexible(
                      child: Text(
                        'PingHR collects location data to enable check-in and check-out functionality even when the app is closed or not in use.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    onChanged: (value) => setState(() => isAccepted = value!),
                  ),
                  GestureDetector(
                    onTap: () {
                      String id = empIdController.text;
                      String password = passController.text;
                      if (id.isEmpty) {
                        Get.snackbar(
                          "Employee ID",
                          "cannot be empty",
                          colorText: Colors.black54,
                          backgroundColor: Colors.blue[50],
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(20.0),
                        );
                      } else if (password.isEmpty) {
                        Get.snackbar(
                          "Password",
                          "cannot be empty",
                          colorText: Colors.black54,
                          backgroundColor: Colors.blue[50],
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(20.0),
                        );
                      } else if (isAccepted) {
                        getLogin(id, password);
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'Please accept aur term and condition before login');
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 15, right: 12,left: 12),
                      height: 45,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(2, 2),
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: screenWidth / 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
