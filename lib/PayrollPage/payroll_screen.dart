import 'package:flutter/material.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Payroll', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Payroll Structure'),
              Tab(text: 'Download Payslip'),
            ],
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue.shade900,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
            indicatorPadding: EdgeInsets.all(5.0),
          ),
        ),
        body: TabBarView(
          children: [
            _buildPayrollStructure(),
            _buildDownloadPayslip(),
          ],
        ),
      ),
    );
  }

  Widget _buildPayrollStructure() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.blue.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Net Salary(KYD)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildColumn('Gross Earning', '3000', Colors.white),
                        _buildColumn('Total Deduction', '233.5', Colors.white),
                        _buildColumn('Total Earning', '2766.5', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildSection('Earning', [
              _buildRow('Basic', '3000'),
              _buildRow('Total', '3000'),
            ]),
            Divider(),
            _buildSection('Employee Contribution', [
              _buildRow('Pension', '150'),
              _buildRow('Health Insurance', '83.5'),
              _buildRow('Total', '233.5'),
            ]),
            Divider(),
            _buildSection('Employer Contribution', [
              _buildRow('Pension', '150'),
              _buildRow('Health Insurance', '83.5'),
              _buildRow('Total', '233.5'),
            ]),
            Divider(),
            _buildSection('Net Salary (KYD)', [
              _buildRow('Gross Earning', '3000'),
              _buildRow('Total Deduction', '233.5'),
              _buildRow('Net Amount', '2766.5'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadPayslip() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Implement download functionality here
        },
        child: Text('Download Payslip'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String amount, Color color) {
    return Flexible(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10)),
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
} 