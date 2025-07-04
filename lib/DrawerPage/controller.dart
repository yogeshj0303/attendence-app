import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:get/get.dart';
import '../class/constants.dart';

class CalController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CalModel> attnData = <CalModel>[].obs;

  Future<void> fetchAttendance() async {
    if (GlobalVariable.uid == null) {
      Fluttertoast.showToast(msg: 'User ID not available. Please login again.');
      return;
    }
    
    final url = '${apiUrl}attendance?id=${GlobalVariable.uid}';
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<CalModel> output = (data['data'] as List)
            .map((e) => CalModel(
                date: e['date'],
                checkIn: e['checkin'],
                checkOut: e['checkout'],
                inLocation: e['checkin_location'] ?? "-----",
                outLocation: e['checkout_location'] ?? '-----',
                workStatus: e['work_status'] ?? 'Not Available',
                compareDate: e['compare_date']))
            .toList();
        attnData.assignAll(output);
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class CalModel {
  final String date;
  final String checkIn;
  final String checkOut;
  final String inLocation;
  final String outLocation;
  final String workStatus;
  final String compareDate;

  CalModel({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.inLocation,
    required this.outLocation,
    required this.workStatus,
    required this.compareDate,
  });
}
