import 'dart:convert';
import 'package:employeeattendance/HomePage/main_screen.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:employeeattendance/controller/globalvariable.dart';

class Login {
  static getLogin(String empId, String password) async {
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
        GlobalVariable.name = data["data"]["name"];
        GlobalVariable.designation = data['data']['designation'];
        GlobalVariable.number = data['data']['number'];
        GlobalVariable.email = data['data']['email'];
        GlobalVariable.image = data['data']['image'];
        GlobalVariable.department = data['data']['department'];
        GlobalVariable.empID = data['data']['empid'];
        GlobalVariable.permanentAdd = data['data']['permanent_add'];
        GlobalVariable.branch = data['data']['branch_allocated'];
        GlobalVariable.joiningDate = data['data']['date_of_join'];
        GlobalVariable.salary = data['data']['salary'];
        // GlobalVariable.currentAdd = data['data']['corres_add'];
        // GlobalVariable.emergencynumber = data['data']['parent_mobile'];
        // GlobalVariable.blood = data['data']['blood_group'];
        print(GlobalVariable.empID);
        print(GlobalVariable.name);
        print(GlobalVariable.designation);
        print(GlobalVariable.number);
        print(GlobalVariable.email);
        print(GlobalVariable.image);
        print(GlobalVariable.department);
        print(GlobalVariable.joiningDate);
        print(GlobalVariable.salary);
        Fluttertoast.showToast(msg: 'Login Successful')
            .then((value) => Get.offAll(() => const MainScreen()));
      } else {
        Fluttertoast.showToast(msg: 'Invalid Employee ID or Password');
      }
    }
  }
}
