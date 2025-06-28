import 'package:cached_network_image/cached_network_image.dart';
import 'package:employeeattendance/DrawerPage/help.dart';
import 'package:employeeattendance/HomePage/main_screen.dart';
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
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Set the status bar color to match the app bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen())),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Reduced padding
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildProfileOption(
                  "Profile",
                  'https://cdn.iconscout.com/icon/free/png-256/profile-3177996-2652436.png',
                  () => Get.to(() => const ProfileDetails()),
                ),
                buildProfileOption(
                  "Personal",
                  'https://cdn-icons-png.flaticon.com/512/2621/2621824.png',
                  () => Get.to(() => const PersonalDetails()),
                ),
                buildProfileOption(
                  "Family",
                  'https://www.pngitem.com/pimgs/m/123-1239549_family-health-icon-png-png-download-family-icon.png',
                  () => Get.to(() => const FamilyDetails()),
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
                  radius: 60, // Reduced size
                  backgroundColor: Colors.white,
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(60.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
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
                    color: Colors.black87,
                    fontFamily: GoogleFonts.arimo().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                buildInfoRow(Icons.person, GlobalVariable.designation, screenWidth),
                buildInfoRow(Icons.apartment, "${GlobalVariable.department} Dept.", screenWidth),
              ],
            ),
            const SizedBox(height: 20),
            buildTile("Upload", FontAwesomeIcons.upload, () => Get.to(() => const UploadDocuments())),
            buildTile("Downloads", FontAwesomeIcons.download, () => Get.to(() => const Downloads())),
            buildTile("Help", FontAwesomeIcons.questionCircle, () => Get.to(() => const SupportScreen())),
            buildTile(
              "Privacy Policy",
              FontAwesomeIcons.shieldAlt,
              () async {
                const String url = 'https://pinghr.in/privacy';
                try {
                  await launchUrl(Uri.parse(url));
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Could not open privacy policy',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
            buildTile(
              "Logout",
              FontAwesomeIcons.powerOff,
              () => Get.defaultDialog(
                title: "Logout?",
                middleText: "Confirm to logout or cancel.",
                onCancel: () => Navigator.pop(context),
                onConfirm: () => AuthLogin.logout(),
                confirmTextColor: Colors.white,
              ),
            ),
            // buildTile(
            //   "Help",
            //   FontAwesomeIcons.questionCircle,
            //   () => Get.defaultDialog(
            //     title: "Help?",
            //     middleText: "This action is permanent.",
            //     onCancel: () => Navigator.pop(context),
            //     onConfirm: () {
            //       Get.to(() => const HelpScreen());
            //     },
            //     confirmTextColor: Colors.white,
            //   ),
            //   textColor: Colors.red,
            // ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Text(
          "All Rights Reserved  |  Act T Connect Pvt. Ltd.",
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildProfileOption(String title, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 80, // Slightly larger for better visibility
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 2, // Slight elevation for a floating effect
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600, // Slightly bolder text
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 18),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: screenWidth / 28,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget buildTile(String title, IconData iconData, VoidCallback onPressed, {Color textColor = Colors.black}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(iconData, color: Colors.blueAccent, size: 18),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

