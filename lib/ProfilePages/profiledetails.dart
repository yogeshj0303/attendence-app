import 'package:employeeattendance/controller/globalvariable.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Divider(),
          ListTile(
            title: const Text("Contact Number"),
            subtitle: Text(GlobalVariable.number),
            leading: Icon(Icons.phone, color: Colors.greenAccent.shade700),
          ),
          const Divider(),
          ListTile(
            title: const Text("Employee ID"),
            subtitle: Text(GlobalVariable.empID),
            leading:
                Icon(Icons.perm_identity_sharp, color: Colors.blue.shade600),
          ),
          const Divider(),
          ListTile(
            title: const Text("Branch"),
            subtitle: Text(GlobalVariable.branch?? 'Null'),
            leading: const Icon(Icons.apartment, color: Colors.red),
          ),
          const Divider(),
          ListTile(
            title: const Text("Salary"),
            subtitle: Text(GlobalVariable.salary ?? 'Null'),
            leading: const Icon(Icons.currency_rupee, color: Colors.blue),
          ),
          const Divider(),
          ListTile(
            title: const Text("E-mail"),
            subtitle: Text(GlobalVariable.email),
            leading: Icon(Icons.mail, color: Colors.orange.shade600),
          ),
          const Divider(),
          ListTile(
            title: const Text("Joining Date"),
            subtitle: Text(GlobalVariable.joiningDate?? 'Null'),
            leading: const Icon(Icons.calendar_month, color: Colors.cyan),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
