import 'package:employeeattendance/DrawerPage/leaveapplication.dart';
import 'package:flutter/material.dart';

class AutoLeaveScreen extends StatefulWidget {
  @override
  State<AutoLeaveScreen> createState() => _AutoLeaveScreenState();
}

class _AutoLeaveScreenState extends State<AutoLeaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        elevation: 0,
        centerTitle: true,
        title: Text('Leave', style: TextStyle(fontWeight: FontWeight.bold)),
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
            ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              selectedColor: Theme.of(context).primaryColor,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Leave Balance'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Holiday Calendar'),
                ),
              ],
              isSelected: [true, false],
              onPressed: (int index) {
                // Handle toggle button selection
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: _buildLeaveTable(),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle leave history
                    },
                    icon: Icon(Icons.history, color: Colors.white),
                    label: Text('Leave History', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  SizedBox(width: 8), // Add spacing between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApplication()));
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Apply Leave', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveTable() {
    return DataTable(
      columnSpacing: 16.0,
      headingRowColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor.withOpacity(0.1)),
      dataRowColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Theme.of(context).primaryColor.withOpacity(0.15);
        }
        return Colors.transparent;
      }),
      columns: [
        DataColumn(
          label: Text(
            'Leave Type',
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
        ),
        DataColumn(
          label: Text(
            'Balance',
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Utilized',
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Pending',
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
          numeric: true,
        ),
      ],
      rows: [
        _buildDataRow('Vacation Leave (VL)', '24', '0', '0'),
        _buildDataRow('Sick Leave (SL)', '24', '0', '0'),
        _buildDataRow('PL (PL)', '10', '2', '0'),
        _buildDataRow('WFH (WFH)', '1', '0', '0'),
      ],
    );
  }

  DataRow _buildDataRow(String type, String balance, String utilized, String pending) {
    return DataRow(
      cells: [
        DataCell(Text(type, style: TextStyle(fontSize: 14))),
        DataCell(Center(child: Text(balance, style: TextStyle(fontSize: 14)))),
        DataCell(Center(child: Text(utilized, style: TextStyle(fontSize: 14)))),
        DataCell(Center(child: Text(pending, style: TextStyle(fontSize: 14)))),
      ],
    );
  }
} 