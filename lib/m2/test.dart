import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  final picker = ImagePicker();

  // ฟังก์ชันเลือกภาพ
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // ฟังก์ชันอัปโหลดภาพและข้อมูลไปยังเซิร์ฟเวอร์
  Future uploadImageAndData() async {
    if (_image == null) {
      print('No image selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // URL ของสคริปต์ PHP บนเซิร์ฟเวอร์ของคุณ
    var uri = Uri.parse("http://${Global.ip_80}/gotwo/regiss.php");

    var request = http.MultipartRequest('POST', uri);


    // เพิ่มไฟล์รูปภาพ
    var pic = await http.MultipartFile.fromPath("image", _image!.path);
    request.files.add(pic);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image and Data Uploaded');
      // แสดงข้อความแจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload successful')),
      );
      // ล้างข้อมูลหลังจากอัปโหลดเสร็จ
 
    } else {
      print('Upload Failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image and Data'),
        backgroundColor: Color(0xFF1A1C43),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // แสดงรูปภาพที่เลือก
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                  )
                : Text('No Image Selected'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Select Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A1C43), // สีพื้นหลังของปุ่ม
              ),
            ),
            SizedBox(height: 20),
          
            ElevatedButton(
              onPressed: uploadImageAndData,
              child: Text('Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A1C43), // สีพื้นหลังของปุ่ม
              ),
            ),
          ],
        ),
      ),
    );
  }
}
