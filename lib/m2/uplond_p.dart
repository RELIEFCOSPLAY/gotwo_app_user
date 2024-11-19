import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image; // เก็บภาพที่เลือก
  String? _uploadedImageUrl; // เก็บ URL รูปภาพที่อัปโหลด

  // ฟังก์ชันเลือกภาพจากแกลเลอรี่
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันอัปโหลดไฟล์ไปยัง Backend
  Future<void> uploadImage() async {
    if (_image == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://${Global.ip_8080}/gotwo/upload_p.php'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);

      if (data['file'] != null) {
        setState(() {
          _uploadedImageUrl = data['file']; // ดึง URL ไฟล์ที่อัปโหลด
        });
      }
    } else {
      print('File upload failed');
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
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
