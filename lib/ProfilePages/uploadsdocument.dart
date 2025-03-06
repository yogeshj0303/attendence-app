import 'dart:io';
import 'package:employeeattendance/ProfilePages/show_upload_doc.dart';
import 'package:employeeattendance/class/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../controller/globalvariable.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({Key? key}) : super(key: key);

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        this.image = tempImage;
        fileController.text = tempImage.path.split('/').last;
      });
    } on PlatformException {
      rethrow;
    }
  }

  final docNameController = TextEditingController();
  final fileController = TextEditingController();
  final docKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  Future<void> uploadDocument(String docName, String imagePath) async {
    final url =
        '${apiUrl}uploading-file?doc_name=$docName&emp_id=${GlobalVariable.empID}';
    isLoading.value = true;
    final request = http.MultipartRequest('Post', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Document submitted successfully');
      docNameController.clear();
      fileController.clear();
      Get.off(() => const ShowUploadDoc());
    } else {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'Server error');
    }
  }

  @override
  void dispose() {
    docNameController.clear();
    fileController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" Upload Documents"),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        actions: [
          IconButton(
              onPressed: () => Get.to(() => const ShowUploadDoc()),
              icon: const Icon(Icons.file_upload))
        ],
      ),
      body: Obx(
        () => isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: docKey,
                    child: Column(
                      children: [
                        Image.asset('assets/images/upload.jpg'),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: docNameController,
                            validator: (value) => value!.isEmpty
                                ? 'Document cannot be empty'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Document name',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Upload Files",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                            "Browse and choose files you want to upload."),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: fileController,
                            readOnly: true,
                            validator: (value) =>
                                value!.isEmpty ? '* Upload document' : null,
                            onTap: () => pickImage(ImageSource.gallery),
                            decoration: const InputDecoration(
                              hintText: 'Upload Document/Image',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            final isValid = docKey.currentState!.validate();
                            if (isValid) {
                              uploadDocument(
                                  docNameController.text, image!.path);
                            }
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            'upload'.toUpperCase(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
