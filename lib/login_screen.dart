import 'dart:convert';
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
import '../styles/text_styles.dart';

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

        print(GlobalVariable.empID);
        print(GlobalVariable.name);
        print(GlobalVariable.designation);
        print(GlobalVariable.number);
        print(GlobalVariable.email);
        print(GlobalVariable.image);
        print(GlobalVariable.department);
        
        AuthLogin.login(empId, password);
        Fluttertoast.showToast(msg: 'Login Successful')
            .then((value) => Get.offAll(() => const MainScreen()));
      } else {
        Fluttertoast.showToast(msg: 'Invalid Employee ID or Password');
      }
    }
  }

  bool isAccepted = false;
  bool _obscurePassword = true;
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xFF2563EB);
  Color secondary = const Color(0xFF64748B);
  TextEditingController empIdController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final Uri url = Uri.parse('http://pinghr.in/privacy-policy');
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Header Section
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Logo Contair
                  Container(
                    height: screenHeight * 0.22,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primary.withOpacity(0.1),
                          primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/Ping-HR.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  // Welcome Text
                  Text(
                    "Welcome Back",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  
                  SizedBox(height: 4),
                  
                  Text(
                    "Sign in to your account to continue",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: secondary,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  // Employee ID Field
                  _buildInputField(
                    label: "Employee ID",
                    hint: "Enter your Employee ID",
                    icon: Icons.person_outline,
                    controller: empIdController,
                    keyboardType: TextInputType.text,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Password Field
                  _buildPasswordField(),
                  
                  SizedBox(height: 12),
                  
                  // Terms and Conditions
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAccepted ? primary.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: isAccepted,
                            activeColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) => setState(() => isAccepted = value!),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF475569),
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to HR Hub '),
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () => launchUrl(url),
                                        child: Text(
                                          'Terms and Conditions',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'PingHR collects location data to enable check-in and check-out functionality even when the app is closed or not in use.',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: secondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Login Button
                  _buildLoginButton(),
                  
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: secondary,
              ),
              prefixIcon: Icon(
                icon,
                color: secondary,
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: passController,
            obscureText: _obscurePassword,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              hintText: "Enter your Password",
              hintStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: secondary,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: secondary,
                size: 18,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: secondary,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            String id = empIdController.text.trim();
            String password = passController.text.trim();
            
            if (id.isEmpty) {
              _showErrorSnackbar("Employee ID cannot be empty");
            } else if (password.isEmpty) {
              _showErrorSnackbar("Password cannot be empty");
            } else if (!isAccepted) {
              Fluttertoast.showToast(
                msg: 'Please accept our terms and conditions before login',
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            } else {
              getLogin(id, password);
            }
          },
          child: Center(
            child: Text(
              "Sign In",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade500,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }
}
