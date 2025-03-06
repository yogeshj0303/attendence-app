import 'package:cached_network_image/cached_network_image.dart';
import 'package:employeeattendance/ProfilePages/downloads.dart';
import 'package:employeeattendance/ProfilePages/familydetails.dart';
import 'package:employeeattendance/ProfilePages/personaldetails.dart';
import 'package:employeeattendance/ProfilePages/profiledetails.dart';
import 'package:employeeattendance/ProfilePages/uploadsdocument.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/model/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/globalvariable.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => const ProfileDetails()),
                      child: SizedBox(
                        height: 50,
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl:
                          'https://cdn.iconscout.com/icon/free/png-256/profile-3177996-2652436.png',
                        ),
                      ),
                    ),
                    const Text("Profile Details"),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => const PersonalDetails()),
                      child: SizedBox(
                        height: 50,
                        width: 80,
                        child: CachedNetworkImage(
                            imageUrl:
                            'https://cdn-icons-png.flaticon.com/512/2621/2621824.png'),
                      ),
                    ),
                    const Text("Personal Details"),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => const FamilyDetails()),
                      child: SizedBox(
                        height: 50,
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl:
                          'https://www.pngitem.com/pimgs/m/123-1239549_family-health-icon-png-png-download-family-icon.png',
                        ),
                      ),
                    ),
                    const Text("Family Details"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 65,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(65.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  GlobalVariable.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: GoogleFonts.arimo().fontFamily,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    Text(
                      GlobalVariable.designation,
                      style: TextStyle(
                        fontSize: screenWidth / 23,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.apartment,
                      color: Colors.blue,
                    ),
                    Text(
                      "${GlobalVariable.department} Department",
                      style: TextStyle(
                        fontSize: screenWidth / 23,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            buildTile("Upload Documents", FontAwesomeIcons.upload,
                    () => Get.to(() => const UploadDocuments())),
            const Divider(),
            buildTile("Downloads", FontAwesomeIcons.download,
                    () => Get.to(() => const Downloads())),
            const Divider(),
            buildTile(
              "Logout",
              FontAwesomeIcons.powerOff,
                  () => Get.defaultDialog(
                title: "Are you sure you want to logout?",
                middleText: "Tap on confirm to logout or cancel to go back",
                onCancel: () => Get.back(),
                onConfirm: () => AuthLogin.logout(),
                confirmTextColor: Colors.white,
              ),
            ),
            const Divider(),
            buildTile(
              "Delete Account",
              FontAwesomeIcons.trashAlt,
                  () => Get.defaultDialog(
                title: "Are you sure you want to delete your account?",
                middleText: "This action is permanent and cannot be undone.",
                onCancel: () => Get.back(),
                onConfirm: () {
                  // Add delete account functionality here
                },
                confirmTextColor: Colors.white,
              ),
              textColor: Colors.red,
            ),
            const Divider(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Text(
          "All Rights Reserved  |  Act-T Connect Pvt. Ltd.",
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildTile(String title, IconData iconData, VoidCallback onPressed,
      {Color textColor = Colors.black}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(iconData, color: Colors.blue, size: 18),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 17, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
