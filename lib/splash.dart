// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'HomePage/main_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  _navigateToMain() async {
    await Future.delayed(const Duration(seconds: 3));
    
    // Check if widget is still mounted before navigation
    if (mounted) {
      Get.offAll(() => const MainScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 120,
              child: Image.asset('assets/images/Ping-HR.png'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              color: Colors.white,
              child: Text(
                "Employee Attendance App",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 103, 182),
                  fontSize: 25,
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Image.asset('assets/images/splash.png'),
          ],
        ),
      ),
    );
  }
}
