import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyAttendancePage extends StatefulWidget {
  @override
  _MyAttendancePageState createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends State<MyAttendancePage> {
  DateTime _currentMonth = DateTime.now();
  List<dynamic> _attendanceData = [];
  String? _Id;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadId();
  }

  Future<void> _loadId() async {
    setState(() {
      _Id = GlobalVariable.uid.toString(); // Default to '113' if not found
      print(_Id);
    });
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    if (_Id == null) return;

    final response = await http.post(Uri.parse('https://pinghr.in/api/attendance?id=$_Id'));

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          _attendanceData = data['data'];
          _selectedDate = DateTime.now();
        });
      }
    } else {
      // Handle error
      print('Failed to load attendance data');
    }
  }

  void _incrementMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _decrementMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  List<DateTime> _getMonthDates(DateTime month) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => DateTime(month.year, month.month, index + 1));
  }

  void _selectDateFromCalendar(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        title: Text('My Attendance', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDateFromCalendar(DateTime.now()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          _buildDetailsCard(),
          _buildSummaryRow(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    List<DateTime> monthDates = _getMonthDates(_currentMonth);
    DateTime today = DateTime.now();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
                onPressed: _decrementMonth,
              ),
              Text(
                DateFormat('MMM yyyy').format(_currentMonth),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.black54),
                onPressed: _incrementMonth,
              ),
            ],
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: monthDates.map((date) {
                bool isToday = date.year == today.year && date.month == today.month && date.day == today.day;
                bool isSelected = _selectedDate != null && date.year == _selectedDate!.year && date.month == _selectedDate!.month && date.day == _selectedDate!.day;
                return GestureDetector(
                  onTap: () => _selectDateFromCalendar(date),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : null,
                      border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text(DateFormat('yyyy').format(date), style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text('${date.day}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(DateFormat('EEE').format(date).toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('Regularization', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    if (_attendanceData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final selectedDateStr = _selectedDate != null ? DateFormat('dd MMMM yyyy').format(_selectedDate!) : null;
    final attendance = _attendanceData.firstWhere(
      (record) => record['date'] == selectedDateStr,
      orElse: () => null,
    );

    if (attendance == null) {
      return Center(child: Text('No attendance data for selected date'));
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', attendance['date']),
            // _buildDetailRow('Shift', attendance['work_status'] ?? 'N/A'),
            _buildDetailRow('In Date', attendance['date']),
            _buildDetailRow('In Time', attendance['checkin']),
            _buildDetailRow('Out Date', attendance['date']),
            _buildDetailRow('Out Time', attendance['checkout'] ?? '--:--'),
            _buildDetailRow('Status', attendance['work_status'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    Color textColor = Colors.black54; // Default color

    if (label == 'Status') {
      if (value.toLowerCase() == 'present') {
        textColor = Colors.green;
      } else if (value.toLowerCase() == 'absent') {
        textColor = Colors.red;
      } else if (value.toLowerCase() == 'half day') {
        textColor = Colors.orange;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('30', 'Total Days', Icons.calendar_today),
          _buildSummaryItem('24', 'Working Days', Icons.work),
          _buildSummaryItem('5', 'Week Off', Icons.weekend),
          _buildSummaryItem('1', 'Holiday', Icons.beach_access),
          _buildSummaryItem('11.5', 'No Pay Days', Icons.money_off),
          _buildSummaryItem('0', 'Leave Days', Icons.airline_seat_flat),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon) {
    return Expanded(
      child: SizedBox(
        width: 100,
        height: 120,
        child: Card(
          color: Colors.white,
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blue.shade900, size: 24),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
} 