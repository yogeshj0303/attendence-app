// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
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
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Text(
                "Employee Attendance App",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 103, 182),
                  fontSize: 25,
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                ),
              ),
            ),
            Image.asset('assets/images/splash.png'),
          ],
        ),
      ),
    );
  }
}
