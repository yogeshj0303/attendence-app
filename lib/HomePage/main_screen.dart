import 'package:employeeattendance/DrawerPage/leaveapplication.dart';
import 'package:employeeattendance/DrawerPage/profile_screen.dart';
import 'package:employeeattendance/DrawerPage/view_attendance.dart';
import 'package:employeeattendance/LeavePage/leave_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of widgets for each tab page (excluding the placeholder)
  final List<Widget> _pages = [
    const HomeScreen(),
    ViewAttendance(),
    const SizedBox.shrink(),
    AutoLeaveScreen(),
    const ProfileScreen(),
  ];

  // Method to handle bottom navigation item selection
  void _onItemTapped(int index) {
    if (index == 2) {
      HomeScreen();
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: _buildBottomNavigationBar(context), // Bottom navigation builder
      ),
    );
  }

  // Build the bottom navigation bar with Cupertino icons
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        // Bottom Navigation Bar
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped, // Update the current index when tapped
          showSelectedLabels: true,
          selectedFontSize: 10, // Increased font size for better visibility
          unselectedFontSize: 10, // Ensure unselected labels are also visible
          showUnselectedLabels: true, // Show unselected labels for better clarity
          selectedItemColor: Colors.blue.shade900,
          unselectedItemColor: Colors.grey.shade400, // Lighter grey for unselected items
          elevation: 12, // Increased elevation for more depth
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white, // White background for a cleaner look
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 24), // Slightly larger icons
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar, size: 24),
              label: 'Attendance',
            ),
            // This is the middle placeholder item for the FAB
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Empty widget for space
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar, size: 24),
              label: 'Leave',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled, size: 24),
              label: 'Profile',
            ),
          ],
        ),
        // Floating Action Button (Add button in the middle)
        Positioned(
          bottom: 20, // Adjusted position for better alignment
          left: MediaQuery.of(context).size.width / 2 - 30, // Center the button
          child: AnimatedScale(
            scale: _currentIndex == 2 ? 1.2 : 1.0, // More pronounced scale effect when FAB is selected
            duration: const Duration(milliseconds: 300), // Slightly longer animation duration
            child: FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApplication()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => AutoLeaveScreen()));
                print("Add button pressed");
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Fully rounded button
              ),
              elevation: 10, // Higher elevation for more depth
              backgroundColor: Colors.blue.shade900,
              child: Icon(
                  Icons.fingerprint_outlined, // Cupertino icon for add
                  size: 28, // Larger icon for the FAB
                  color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }
}
