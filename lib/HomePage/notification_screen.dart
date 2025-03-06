import 'dart:convert';
import 'package:employeeattendance/HomePage/main_screen.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../controller/globalvariable.dart';
import '../model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final smallLightText = const TextStyle(
    fontSize: 14,
    color: Colors.black45,
  );

  final xLargeLightText = const TextStyle(
    fontSize: 22,
    color: Colors.black45,
  );

  final largeText = const TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  Future<NotificationModel> getNotification() async {
    final url = '${apiUrl}show-notification?emp_id=${GlobalVariable.empID}';
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        return NotificationModel.fromJson(data);
      } else {
        Fluttertoast.showToast(msg: 'error true');
      }
    } else {
      Fluttertoast.showToast(msg: '${response.reasonPhrase}');
    }
    throw Exception('Unable to load data');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(),));
          },
        ),
        backgroundColor: Colors.blue.shade900,
        title: const Text('Notification', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<NotificationModel>(
            future: getNotification(),
            builder: (context, snapshot) => snapshot.hasData
                ? snapshot.data!.notifiication!.isEmpty
                    ? noNotification(size)
                    : notificationCard(snapshot, size)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Center noNotification(Size size) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.2),
          const Icon(Icons.circle_notifications, size: 170, color: Colors.blue),
          Text('No Notifications Yet', style: xLargeLightText)
        ],
      ),
    );
  }

  Widget notificationCard(
      AsyncSnapshot<NotificationModel> snapshot, Size size) {
    final item = snapshot.data!.notifiication!;
    int length = item.length;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          color: Colors.white,
          width: size.width,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item[index].msg!,
                style: largeText,
              ),
              SizedBox(
                width: size.width - 35,
                child: Text(
                  item[index].docList!,
                  style: smallLightText,
                ),
              ),
              Text(
                item[index].createdAt!.split(' ').last.substring(0, 5),
                style: smallLightText,
              ),
              Text(
                item[index].createdAt!.split(' ').first.substring(0, 10),
                style: smallLightText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
