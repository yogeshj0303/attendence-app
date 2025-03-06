import 'package:cached_network_image/cached_network_image.dart';
import 'package:employeeattendance/DrawerPage/expense/expense_controller.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowExpense extends StatelessWidget {
  ShowExpense({super.key});
  final c = Get.put(ExpenseController());
  @override
  Widget build(BuildContext context) {
    c.fetchExpense();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Expenses'),
        elevation: 1,
      ),
      body: Obx(
        () => c.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: c.allExpense.length,
                itemBuilder: (context, index) => buildCard(index),
              ),
      ),
    );
  }

  buildCard(int index) {
    final item = c.allExpense[index];
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      color: Colors.white,
      child: Row(
        children: [
          item.image == ''
              ? const SizedBox(
                  height: 85,
                  width: 70,
                  child: Center(
                    child: Text(
                      'NA',
                      style: TextStyle(color: Colors.black26, fontSize: 32),
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: '$imgPath/${item.image!}', height: 85, width: 70),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.date,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                item.itemName,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                '₹${item.amount}/-',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              item.status == '0'
                  ? Text(
                      'In Process',
                      style: TextStyle(
                          color: Colors.yellow.shade500, fontSize: 16),
                    )
                  : item.status == '2'
                      ? Text(
                          'Credited',
                          style: TextStyle(
                              color: Colors.green.shade500, fontSize: 16),
                        )
                      : Text(
                          'Rejected',
                          style: TextStyle(
                              color: Colors.red.shade500, fontSize: 16),
                        ),
            ],
          ),
        ],
      ),
    );
  }
}
