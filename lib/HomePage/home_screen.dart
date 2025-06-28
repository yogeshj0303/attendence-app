import 'dart:convert';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:employeeattendance/DrawerPage/about_us.dart';
import 'package:employeeattendance/DrawerPage/expense/expense.dart';
import 'package:employeeattendance/DrawerPage/help.dart';
import 'package:employeeattendance/DrawerPage/appliedleave.dart';
import 'package:employeeattendance/DrawerPage/learning_screen.dart';
import 'package:employeeattendance/DrawerPage/leaveapplication.dart';
import 'package:employeeattendance/DrawerPage/calender.dart';
import 'package:employeeattendance/HomePage/notification_screen.dart';
import 'package:employeeattendance/HomePage/today_screen.dart';
import 'package:employeeattendance/PayrollPage/payroll_screen.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:employeeattendance/controller/location.dart';
import 'package:employeeattendance/model/birthday_model.dart';
import 'package:employeeattendance/model/events_data.dart';
import 'package:employeeattendance/model/rewardmodel.dart';
import 'package:employeeattendance/model/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../DrawerPage/profile_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  bool isLoaded = false;
  final LocationService _locationService = LocationService();
  Timer? _locationTimer;
  Future<EventsData>? _newsDataFuture; // Cache for news data
  Future<BirthdayModel>? _birthdayDataFuture; // Cache for birthday data
  Future<RewardModel>? _rewardDataFuture; // Cache for reward data
  TextStyle boldText =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);
  TextStyle text = const TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle lightText = const TextStyle(color: Colors.black45, fontSize: 14);
  TextStyle whiteText = const TextStyle(color: Colors.white, fontSize: 16);
  TextStyle whiteSText = const TextStyle(
      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600);
  
  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      await _locationService.initialize();
      
      // Set up a timer to periodically check location status (reduced frequency)
      _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (mounted) {
          setState(() {
            // This will trigger a rebuild to show updated location status
          });
        }
      });
    } catch (e) {
      print('Error initializing location in home screen: $e');
      // Continue with the screen even if location fails
    }
  }

  // Method to refresh news data
  void _refreshNewsData() {
    setState(() {
      _newsDataFuture = _getEventsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "TECH HR",
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const NotificationScreen()),
            icon: const Icon(Icons.notifications, color: Colors.white, size: 20),
          ),
          IconButton(
            onPressed: () => Get.defaultDialog(
              backgroundColor: Colors.white,
              buttonColor: Colors.blue.shade900,
              title: "Are you sure you want to logout?",
              middleText: "Tap on confirm to logout or cancel to go back",
              onCancel: () => Get.back(),
              onConfirm: () => AuthLogin.logout(),
              confirmTextColor: Colors.white,
            ),
            tooltip: "Logout",
            icon: const Icon(
              Icons.logout,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(10),
              children: [
                buildPunchIn(),
                const SizedBox(height: 10),
                buildSection(
                  title: "News & Updates",
                  child: buildNews(),
                ),
                const SizedBox(height: 10),
                buildSection(
                  title: "Leave & Attendance",
                  child: buildTime(),
                ),
                const SizedBox(height: 10),
                buildSection(
                  title: "Birthdays and Anniversaries",
                  child: buildBirthday(),
                ),
                const SizedBox(height: 10),
                buildSection(
                  title: "Rewards & Recognition",
                  child: buildReward(),
                ),
              ],
            ),
    );
  }

  Container buildPunchIn() {
    return Container(
      height: screenHeight / 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.fingerprint_outlined,
            color: Colors.green,
            size: 60,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Text(
                GlobalVariable.checkInStatus == 0
                    ? 'Check In'
                    : GlobalVariable.checkOutStatus == 0
                        ? 'Check Out'
                        : 'Done',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  "${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getLocationStatusText(),
                        style: TextStyle(
                          color: _getLocationStatusColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_locationService.locationStatus == "Fetching")
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    if (_locationService.locationStatus == "Permission Required" ||
                        _locationService.locationStatus == "Error")
                      GestureDetector(
                        onTap: () async {
                          await _locationService.refreshLocation();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 12,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (GlobalVariable.location != '') {
                Get.to(() => const TodayScreen());
              } else {
                setState(() {
                  isLoaded = true;
                });
                Future.delayed(
                  const Duration(milliseconds: 200),
                  () => Get.to(() => const TodayScreen())!.then(
                    (value) => setState(() {
                      isLoaded = false;
                    }),
                  ),
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: screenWidth / 3.5,
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    GlobalVariable.checkInStatus == 0
                        ? 'Check In '
                        : GlobalVariable.checkOutStatus == 0
                            ? 'Check Out '
                            : 'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReward() {
    // Initialize the future only once
    _rewardDataFuture ??= _getRewardData();
    
    return SizedBox(
      height: screenHeight / 4.5,
      child: FutureBuilder<RewardModel>(
        future: _rewardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading rewards...', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            print('Reward FutureBuilder error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Error loading rewards',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshRewardData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.data!.length,
              itemBuilder: (context, index) =>
                  buildRewardList(snapshot, index),
            );
          }

          return Container(
            width: screenWidth / 1.06,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  Widget buildRewardList(AsyncSnapshot<RewardModel> snapshot, int index) {
    return Container(
      width: screenWidth / 1.06,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              FontAwesomeIcons.handsClapping,
              size: 45,
              color: Colors.greenAccent.shade700,
            ),
            SizedBox(
              height: 40,
              width: screenWidth / 1.2,
              child: Text(
                snapshot.data!.data![index].title.toString(),
                style: text,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              snapshot.data!.data![index].des.toString(),
              style: lightText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<RewardModel> _getRewardData() async {
    final url = '${apiUrl}rewards';
    print('Reward API URL: $url');

    try {
      print('Making reward API request to: $url');
      var response = await http.post(Uri.parse(url));
      print('Reward Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('Reward data received: $data');
        return RewardModel.fromJson(data);
      } else {
        print('Reward API request failed with status: ${response.statusCode}');
        throw Exception('Failed to load reward data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getRewardData: $e');
      throw Exception('Error loading reward data: $e');
    }
  }

  // Method to refresh reward data
  void _refreshRewardData() {
    setState(() {
      _rewardDataFuture = _getRewardData();
    });
  }

  Widget buildBirthday() {
    // Initialize the future only once
    _birthdayDataFuture ??= _getBirthdayData();
    
    return SizedBox(
      height: screenHeight / 6,
      child: FutureBuilder<BirthdayModel>(
        future: _birthdayDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading birthdays...', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            print('Birthday FutureBuilder error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Error loading birthdays',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshBirthdayData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data!.data!.isEmpty) {
              // Case when there are no birthdays
              return Center(
                child: Container(
                  height: screenHeight / 6.5,
                  width: 270,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.birthdayCake,
                          size: 40,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No Birthdays Today",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // Case when there are birthdays
              return ListView.builder(
                itemCount: snapshot.data!.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    buildBirthListView(snapshot, index),
              );
            }
          }

          // Case when there's an error or no data
          return Center(
            child: Text(
              "No data available",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Future<BirthdayModel> _getBirthdayData() async {
    final url = '${apiUrl}dob';
    print('Birthday API URL: $url');

    try {
      print('Making birthday API request to: $url');
      var response = await http.post(Uri.parse(url));
      print('Birthday Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('Birthday data received: $data');
        return BirthdayModel.fromJson(data);
      } else {
        print('Birthday API request failed with status: ${response.statusCode}');
        throw Exception('Failed to load birthday data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBirthdayData: $e');
      throw Exception('Error loading birthday data: $e');
    }
  }

  // Method to refresh birthday data
  void _refreshBirthdayData() {
    setState(() {
      _birthdayDataFuture = _getBirthdayData();
    });
  }

  Widget buildBirthListView(AsyncSnapshot<BirthdayModel> snapshot, int index) {
    return Stack(
      children: [
        Container(
          height: screenHeight / 6.5,
          width: 270,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    '$imgLink${snapshot.data!.data![index].image.toString()}'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.data!.data![index].name.toString()),
                  Text(snapshot.data!.data![index].dob.toString()),
                ],
              ),
              const Icon(FontAwesomeIcons.cakeCandles,
                  size: 40, color: Colors.red)
            ],
          ),
        ),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.blue.shade900,
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
              
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              GlobalVariable.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.arimo().fontFamily,
                              ),
                            ),
                            Text(
                              GlobalVariable.email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              GlobalVariable.number,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white70, height: 0, indent: 20, endIndent: 20),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.houseChimneyUser,
                    title: "Home",
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.idCard,
                    title: "Profile",
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.calendarDay,
                    title: "Attendance",
                    onTap: () => Get.to(() => const Calender()),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      leading: Icon(FontAwesomeIcons.personWalkingArrowRight, color: Colors.white, size: 20),
                      title: Text(
                        "Leaves",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      childrenPadding: EdgeInsets.only(bottom: 8),
                      backgroundColor: Colors.blue.shade900,
                      collapsedBackgroundColor: Colors.transparent,
                      children: [
                        _buildDrawerSubItem(
                          title: "Apply for Leave",
                          icon: FontAwesomeIcons.fileCirclePlus,
                          onTap: () => Get.to(() => const LeaveApplication()),
                        ),
                        _buildDrawerSubItem(
                          title: "Leave Request History",
                          icon: FontAwesomeIcons.clockRotateLeft,
                          onTap: () => Get.to(() => const AppliedLeave()),
                        ),
                      ],
                    ),
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.sackDollar,
                    title: "Expense",
                    onTap: () => Get.to(() => const Expenses()),
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.questionCircle,
                    title: "Payroll",
                    onTap: () => Get.to(() => const PayrollScreen()),
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.list,
                    title: "Learning",
                    onTap: () => Get.to(() => LearningScreen()),
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.addressCard,
                    title: "About Us",
                    onTap: () => Get.to(() => const AboutUs()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "All rights reserved | Act T Connect Pvt. Ltd.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontFamily: GoogleFonts.arimo().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Function onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.white,
      ),
      onTap: () => onTap(),
    );
  }

  Widget _buildDrawerSubItem({
    required String title,
    required IconData icon,
    required Function onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
      minLeadingWidth: 20,
      leading: Icon(
        icon,
        color: Colors.white70,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12,
        color: Colors.white70,
      ),
      onTap: () => onTap(),
      dense: true,
    );
  }

  Widget buildTime() {
    return Container(
      height: screenHeight / 5,
      margin: const EdgeInsets.all(10),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                 Icon(
                  Icons.calendar_month,
                  size: 45,
                  color: Colors.blue.shade900,
                ),
                Text("Absences in this month", style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ), textAlign: TextAlign.center),
                Text("No Leave is Available", style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ), textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => const LeaveApplication()),
                  child: Container(
                    height: 30,
                    width: screenWidth / 3,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Apply Leave ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                      ],
                    )
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const AppliedLeave()),
                  child: Container(
                    height: 30,
                    width: screenWidth / 3,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Leave History ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                      ],
                    )
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const Calender()),
                  child: Container(
                    height: 30,
                    width: screenWidth / 3,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Attendance ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildNews() {
    // Initialize the future only once
    _newsDataFuture ??= _getEventsData();
    
    return SizedBox(
      height: screenHeight / 5,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshNewsData();
          // Wait for the future to complete
          await _newsDataFuture;
        },
        child: FutureBuilder<EventsData>(
          future: _newsDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading news...', style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              print('FutureBuilder error: ${snapshot.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Error loading news',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refreshNewsData,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData) {
              print('News data received: ${snapshot.data?.data?.length ?? 0} items');
              if (snapshot.data!.data!.isNotEmpty) {
                return CarouselSlider.builder(
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index, realIndex) {
                    return buildNewsList(snapshot, index);
                  },
                  options: CarouselOptions(
                    height: screenHeight / 5,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 1,
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.newspaper, color: Colors.grey, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'No news available',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
            }

            return Center(
              child: Text(
                "No data available",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<EventsData> _getEventsData() async {
    // Try different possible endpoint names
    final possibleUrls = [
      '${apiUrl}newsevent',
      '${apiUrl}news-event',
      '${apiUrl}news',
      '${apiUrl}events',
      '${apiUrl}news-events',
    ];
    
    print('Trying news API URLs: $possibleUrls');
    
    for (String url in possibleUrls) {
      try {
        print('Trying API request to: $url');
        
        // Try POST first
        var response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        
        print('POST Response for $url - status code: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          try {
            var data = jsonDecode(response.body.toString());
            print('Success with POST on $url - Parsed data: $data');
            print('Response body length: ${response.body.length}');
            print('Response headers: ${response.headers}');
            
            // Check if the response has the expected structure
            if (data is Map<String, dynamic>) {
              if (data.containsKey('data')) {
                return EventsData.fromJson(data);
              } else if (data.containsKey('error') || data.containsKey('message')) {
                // Try to create EventsData with empty data if error is false
                if (data['error'] == false) {
                  return EventsData(error: false, message: data['message'], data: []);
                }
              }
            }
            
            // If we get here, the structure is unexpected
            print('Unexpected response structure: $data');
            throw Exception('Unexpected response structure');
          } catch (e) {
            print('Error parsing JSON from $url: $e');
            throw Exception('Error parsing response: $e');
          }
        } else if (response.statusCode == 405) {
          // Method not allowed, try GET
          print('POST not allowed on $url, trying GET...');
          response = await http.get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          
          print('GET Response for $url - status code: ${response.statusCode}');
          print('GET Response body: ${response.body}');
          
          if (response.statusCode == 200) {
            try {
              var data = jsonDecode(response.body.toString());
              print('Success with GET on $url - Parsed data: $data');
              
              // Check if the response has the expected structure
              if (data is Map<String, dynamic>) {
                if (data.containsKey('data')) {
                  return EventsData.fromJson(data);
                } else if (data.containsKey('error') || data.containsKey('message')) {
                  // Try to create EventsData with empty data if error is false
                  if (data['error'] == false) {
                    return EventsData(error: false, message: data['message'], data: []);
                  }
                }
              }
              
              // If we get here, the structure is unexpected
              print('Unexpected response structure: $data');
              throw Exception('Unexpected response structure');
            } catch (e) {
              print('Error parsing JSON from $url: $e');
              throw Exception('Error parsing response: $e');
            }
          }
        } else {
          print('Response body for $url: ${response.body}');
        }
      } catch (e) {
        print('Error trying $url: $e');
        continue; // Try next URL
      }
    }
    
    // If we get here, none of the URLs worked
    throw Exception('Failed to load news data from any endpoint');
  }

  Widget buildNewsList(AsyncSnapshot<EventsData> snapshot, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
      height: screenHeight / 6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.newspaper,
                    size: 45,
                    color: Colors.blue.shade900,
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data!.data![index].title.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: screenWidth / 1.5,
                          child: Text(
                            snapshot.data!.data![index].des.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  String _getLocationStatusText() {
    final status = _locationService.locationStatus;
    if (status == "Fetching") {
      return "Location: Fetching";
    } else if (status == "Permission Required") {
      return "Location: Permission Required";
    } else if (status == "Error") {
      return "Location: Error";
    } else {
      return "Location: Available";
    }
  }

  Color _getLocationStatusColor() {
    final status = _locationService.locationStatus;
    if (status == "Fetching") {
      return Colors.blue;
    } else if (status == "Permission Required") {
      return Colors.orange;
    } else if (status == "Error") {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

}
