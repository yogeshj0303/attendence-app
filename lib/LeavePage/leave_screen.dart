import 'package:employeeattendance/DrawerPage/appliedleave.dart';
import 'package:employeeattendance/DrawerPage/leaveapplication.dart';
import 'package:employeeattendance/HomePage/main_screen.dart';
import 'package:employeeattendance/api_services.dart';
import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:flutter/material.dart';
import 'package:employeeattendance/LeavePage/leave_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:employeeattendance/models/holiday.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AutoLeaveScreen extends StatefulWidget {
  @override
  State<AutoLeaveScreen> createState() => _AutoLeaveScreenState();
}

class _AutoLeaveScreenState extends State<AutoLeaveScreen> {
  List<bool> _isSelected = [true, false];
  Map<DateTime, List<String>> _holidays = {};
  final ApiService _holidayService = ApiService();
  List<Map<String, dynamic>> _leaveData = [];
  String _employeeId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    setState(() {
      _employeeId = GlobalVariable.empID;
    });
    await _fetchHolidays();
    await _fetchLeaveData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchHolidays() async {
    try {
      List<Holiday> holidays = await _holidayService.fetchHolidays();
      setState(() {
        _holidays = {
          for (var holiday in holidays) holiday.date: [holiday.name]
        };
      });
    } catch (e) {
      print('Error fetching holidays: $e');
    }
  }

  Future<void> _fetchLeaveData() async {
    try {
      List<Map<String, dynamic>> leaveData = await _holidayService.fetchLeaveData(_employeeId);
      setState(() {
        _leaveData = leaveData;
      });
    } catch (e) {
      print('Error fetching leave data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
        centerTitle: true,
        title: Text('Leaves', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                fillColor: Colors.blue.shade900.withOpacity(0.1),
                selectedColor: Colors.blue.shade900,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text('Leave Balance'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text('Holiday Calendar'),
                  ),
                ],
                isSelected: _isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = i == index;
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isSelected[0]
                  ? _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _buildLeaveDataTable()
                  : _buildHolidayCalendar(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppliedLeave()),
                    );
                  },
                  icon: Icon(Icons.history, color: Colors.white),
                  label: Text('Leave History', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaveApplication()),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Apply Leave', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveDataTable() {
    return ListView.builder(
      itemCount: _leaveData.length,
      itemBuilder: (context, index) {
        final leave = _leaveData[index];
        final startDate = parseCustomDate(leave['start_date']);
        final endDate = parseCustomDate(leave['end_date']);
        final leaveCount = endDate.difference(startDate).inDays + 1;
        final status = leave['status'] == '2' ? 'Rejected' : 'Approved on ${leave['approved_date'] ?? 'N/A'}';

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Leave Type: ${leave['type']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      Icon(Icons.beach_access, color: Colors.blue.shade900),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Reason: ${leave['region']}',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date: ${leave['start_date']}',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        'End Date: ${leave['end_date']}',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Leave Count: $leaveCount',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontSize: 14,
                      color: status.contains('Rejected') ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHolidayCalendar() {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime.utc(2025, 1, 1);
    DateTime lastDay = DateTime.utc(2025, 12, 31);
    DateTime focusedDay = now.isBefore(firstDay) ? firstDay : (now.isAfter(lastDay) ? lastDay : now);

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      eventLoader: (day) {
        return _holidays[day] ?? [];
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue.shade200,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue.shade900,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  DateTime parseCustomDate(String dateString) {
    final parts = dateString.split('-');
    final day = int.parse(parts[0]);
    final month = _monthStringToNumber(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  int _monthStringToNumber(String month) {
    switch (month.toLowerCase()) {
      case 'jan': return 1;
      case 'feb': return 2;
      case 'mar': return 3;
      case 'apr': return 4;
      case 'may': return 5;
      case 'jun': return 6;
      case 'jul': return 7;
      case 'aug': return 8;
      case 'sep': return 9;
      case 'oct': return 10;
      case 'nov': return 11;
      case 'dec': return 12;
      default: throw FormatException('Invalid month format');
    }
  }
} 