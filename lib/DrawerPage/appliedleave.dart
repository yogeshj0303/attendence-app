import 'dart:convert';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:employeeattendance/model/data_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AppliedLeave extends StatelessWidget {
  const AppliedLeave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Future<DataModel> getLeaveData() async {
      final url = '${apiUrl}leavedata?emp_id=${GlobalVariable.empID}';
      var response = await http.post(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
      return DataModel.fromJson(data);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Leave Request", style: TextStyle(color: Colors.white)),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: FutureBuilder<DataModel>(
          future: getLeaveData(),
          builder: (context, snapshot) => snapshot.hasData
              ? snapshot.data!.employeeLeaveData!.isEmpty
                  ? const Center(
                      child: Text(
                        "You have not applied for any leave",
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.employeeLeaveData!.length,
                      itemBuilder: (context, index) =>
                          buildHistoryCard(snapshot, index))
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget buildHistoryCard(AsyncSnapshot<DataModel> snapshot, int index) {
    TextStyle text = const TextStyle(fontSize: 15, color: Colors.black54);
    TextStyle smallText = const TextStyle(fontSize: 13, color: Colors.black54);
    TextStyle headText = const TextStyle(
        fontSize: 17, color: Colors.black87, fontWeight: FontWeight.bold);
    String? status = snapshot.data!.employeeLeaveData![index].status;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: Colors.black12)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 22,
              width: 90,
              decoration: BoxDecoration(
                color: status == "0"
                    ? Colors.yellow
                    : status == "1"
                        ? Colors.green
                        : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status! == "0" ? "Pending" : "Approved",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${snapshot.data!.employeeLeaveData![index].type}",
              style: headText,
            ),
            Text(
              "${snapshot.data!.employeeLeaveData![index].region}",
              textAlign: TextAlign.center,
              style: text,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${snapshot.data!.employeeLeaveData![index].startDate} - ",
                  style: smallText,
                ),
                Text(
                  "${snapshot.data!.employeeLeaveData![index].endDate}",
                  style: smallText,
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
