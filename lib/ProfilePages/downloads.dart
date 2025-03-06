import 'dart:convert';
import 'dart:io';
import 'package:employeeattendance/class/constants.dart';
import 'package:employeeattendance/model/download_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../controller/globalvariable.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  RxBool isLoading = false.obs;

  Future<DownloadModel> getDownloads() async {
    final url = '${apiUrl}view-document?emp_id=${GlobalVariable.empID}';
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        return DownloadModel.fromJson(data);
      } else {
        Fluttertoast.showToast(msg: 'error true');
      }
    } else {
      Fluttertoast.showToast(msg: 'Server error');
    }
    throw Exception('Unable to load');
  }

  Future<String> downloadDoc(String pdfUrl, String fileName) async {
    isLoading.value = true;
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/$fileName.pdf';
      final file = await File(path).create();
      file.writeAsBytes(response.bodyBytes);
      OpenFile.open(path);
      isLoading.value = false;
      return 'file.path';
    } else {
      isLoading.value = false;
      throw Exception(
          'Failed to download image. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Downloads"),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/Download-bro.png', height: 200),
            const Icon(
              Icons.download,
              size: 50,
              color: Colors.blue,
            ),
            Obx(
              () => isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<DownloadModel>(
                      future: getDownloads(),
                      builder: (context, snapshot) => snapshot.hasData
                          ? snapshot.data!.data!.isEmpty
                              ? emptyData()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) =>
                                      buildDownloadCard(snapshot, index))
                          : const Center(child: CircularProgressIndicator()),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  buildDownloadCard(AsyncSnapshot<DownloadModel> snapshot, int index) {
    final item = snapshot.data!.data![index];
    return GestureDetector(
      onTap: () => downloadDoc('$imgLink/${item.doc}', item.title!),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title!.toUpperCase(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(item.doc!),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Click to download',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  emptyData() {
    return const Center(
      child: Text(
        "No data found for download.....",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
