import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image; // เก็บภาพที่เลือก
  String? _uploadedImageUrl; // เก็บ URL รูปภาพที่อัปโหลด

  // ฟังก์ชันเลือกและอัปโหลดภาพ
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // เปลี่ยนชื่อไฟล์เป็น "GP_timestamp"
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final directory = await getTemporaryDirectory();
      final newFileName = "GP_$timestamp${path.extension(pickedFile.path)}";
      final newFilePath = path.join(directory.path, newFileName);

      final renamedFile = await File(pickedFile.path).copy(newFilePath);

      setState(() {
        _image = renamedFile; // ใช้ไฟล์ที่เปลี่ยนชื่อ
      });

      // อัปโหลดไฟล์
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${Global.ip_8080}/gotwo/upload_p.php'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);

        if (data['file'] != null) {
          setState(() {
            _uploadedImageUrl = data['file']; // ดึง URL ไฟล์ที่อัปโหลด
            debugPrint(_uploadedImageUrl);
          });
        }
      } else {
        print('File upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload & Display Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // แสดงภาพที่เลือก
            _image != null
                ? Image.file(_image!, height: 200)
                : Text('No image selected'),

            SizedBox(height: 20),

            // แสดงภาพที่อัปโหลดจาก URL
            _uploadedImageUrl != null
                ? Image.network(_uploadedImageUrl!, height: 200)
                : Text('No uploaded image'),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                pickAndUploadImage();
              },
              child: Text('Pick and Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
