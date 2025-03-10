import 'package:employeeattendance/class/login.dart';
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:employeeattendance/login_screen.dart';
import 'package:employeeattendance/model/auth_controller.dart';
import 'package:employeeattendance/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PingHR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: FutureBuilder(
        future: AuthLogin.tryAutoLogin(),
        builder: (context, authResult) {
          if (authResult.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            );
          } else {
            if (authResult.data == true) {
              Login.getLogin(GlobalVariable.empID, GlobalVariable.password);
              return const Splash();
            } else {
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }
}
