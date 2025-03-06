import 'dart:convert';
import 'package:employeeattendance/DrawerPage/appliedleave.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class LeaveApplication extends StatefulWidget {
  const LeaveApplication({Key? key}) : super(key: key);

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  bool isLoading = false;

  Future<void> applyForLeave(
      String type, String reason, String fromDate, String toDate) async {
    final url =
        '${apiUrl}leave?emp_id=${GlobalVariable.empID}&type=$type&region=$reason&start_date=$fromDate&end_date=$toDate';
    setState(() {
      isLoading = true;
    });
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      if (data['error'] == false) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Leave applied successfully');
        Get.off(() => const AppliedLeave());
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: '${response.statusCode} ${response.reasonPhrase}');
    }
  }

  String selectedValue = "-----";
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  List<String> leaveType = [
    "-----",
    "Half Day",
    "Sick leave request",
    "Casual Leave request",
    "Maternity Leave request",
    "Compensatory Leave request",
    "Unpaid Leave request",
    "Work from Home",
  ];
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    leaveType.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blue.shade900,
        title: const Text("Leave Application Form",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Type of leave :",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: selectedValue,
                    items: leaveType
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Center(
                              child: Text(item),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          selectedValue = value!;
                        })),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Reason :",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write specific reason.....",
                      suffixIcon: Icon(Icons.app_registration),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "From :",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2025));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat("dd-MMM-yyyy").format(pickedDate);
                        setState(() {
                          fromDateController.text = formattedDate;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "DD/MM/YYYY",
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                    controller: fromDateController,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "To :",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2025));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat("dd-MMM-yyyy").format(pickedDate);
                        setState(() {
                          toDateController.text = formattedDate;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "DD/MM/YYYY",
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                    controller: toDateController,
                  ),
                  const SizedBox(height: 35),
                  GestureDetector(
                    onTap: () {
                      String type = selectedValue;
                      if (reasonController.text.isNotEmpty ||
                          fromDateController.text.isNotEmpty ||
                          toDateController.text.isNotEmpty ||
                          type != "-----") {
                        applyForLeave(selectedValue, reasonController.text,
                            fromDateController.text, toDateController.text);
                        reasonController.clear();
                        fromDateController.clear();
                        toDateController.clear();
                        setState(() {
                          selectedValue = '-----';
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please fill in all details');
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                          child: Text(
                        "APPLY",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
