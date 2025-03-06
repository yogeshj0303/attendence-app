import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../class/constants.dart';
import '../controller/globalvariable.dart';
import '../model/showdoc_model.dart';

class ShowUploadDoc extends StatefulWidget {
  const ShowUploadDoc({super.key});

  @override
  State<ShowUploadDoc> createState() => _ShowUploadDocState();
}

class _ShowUploadDocState extends State<ShowUploadDoc> {
  RxBool isLoading = false.obs;
  Future<ShowDocModel> getUploadedDoc() async {
    final url = '${apiUrl}emp-document?emp_id=${GlobalVariable.empID}';
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        return ShowDocModel.fromJson(data);
      } else {
        Fluttertoast.showToast(msg: 'error true');
      }
    } else {
      Fluttertoast.showToast(msg: 'Server error');
    }
    throw Exception('Unable to load');
  }

  Future<String> downloadDoc(String url, String fileName) async {
    isLoading.value = true;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/$fileName';
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
      appBar: AppBar(
        title: const Text('Uploaded Documents'),
        elevation: 1,
      ),
      body: Obx(
        () => isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<ShowDocModel>(
                future: getUploadedDoc(),
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
    );
  }

  buildDownloadCard(AsyncSnapshot<ShowDocModel> snapshot, int index) {
    final item = snapshot.data!.data![index];
    return GestureDetector(
      onTap: () => downloadDoc('$imgPath/${item.storePath}', item.storePath!),
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
                      item.documentName!.toUpperCase(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(item.storePath!),
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
