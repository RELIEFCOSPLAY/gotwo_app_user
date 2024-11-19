import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:gotwo_app_user/m2/bank.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emaiController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  static const List<String> list = <String>[
    'Male',
    'Female',
  ];
  String dropdownValue = list.first;
  File? _image; // เก็บภาพที่เลือก
  String? _uploadedImageUrl; // เก็บ URL รูปภาพที่อัปโหลด

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
          });
        }
      } else {
        print('File upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white,
          Colors.white,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: _backButton(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 70),
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            color: Color(0xff1a1c43),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _addPhoto(),
              const SizedBox(height: 20),
              _inputField("Username", usernameController),
              const SizedBox(height: 10),
              _inputField("Email", emaiController),
              const SizedBox(height: 10),
              _inputField("Phone number", phoneController),
              const SizedBox(height: 10),
              _dropdown(),
              const SizedBox(height: 10),
              _inputField("Create Password", createPasswordController,
                  isPassword: true),
              const SizedBox(height: 10),
              _inputField("Confirm Password", confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 15),
              _registerBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        size: 30,
        color: Color(0xff1a1c43),
      ),
    );
  }

  Widget _addPhoto() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffffffff),
            elevation: 0.0,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            pickAndUploadImage(); // เรียกใช้งานฟังก์ชันเพื่อเลือกรูปภาพ
          },
          child: Container(
            width: 70, // ตั้งขนาดของ Container
            height: 70, // ตั้งขนาดของ Container
            decoration: BoxDecoration(
              color: const Color(0xff1a1c43),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xff1a1c43),
                width: 3,
              ),
            ),
            child:
                _uploadedImageUrl != null // ตรวจสอบว่ามีรูปภาพที่เลือกหรือไม่
                    ? ClipOval(
                        // ใช้ ClipOval เพื่อทำให้รูปเป็นวงกลม
                        child: _uploadedImageUrl != null
                            ? Image.network(_uploadedImageUrl!, height: 200)
                            : const Text('No uploaded image'),
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 25,
                      ),
          ),
        ),
      ],
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xff1a1c43)));

    return ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 50,
        ),
        child: TextField(
          style: const TextStyle(color: Color(0xff1a1c43)),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xff1a1c43)),
            enabledBorder: border,
            focusedBorder: border,
          ),
          obscureText: isPassword,
        ));
  }

  Widget _dropdown() {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xff1a1c43)));

    return ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 50,
        ),
        child: DropdownButtonFormField<String>(
          hint: const Text('Gender'),
          decoration: InputDecoration(
            enabledBorder: border,
            focusedBorder: border,
          ),
          value: dropdownValue,
          elevation: 16,
          style: const TextStyle(
              color: Color(0xff1a1c43), fontWeight: FontWeight.bold),
          borderRadius: BorderRadius.circular(30),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }

  Widget _registerBtn() {
    return ElevatedButton(
      onPressed: () {
        // ตรวจสอบว่าข้อมูลครบถ้วนหรือไม่
        if (usernameController.text.isEmpty ||
            emaiController.text.isEmpty ||
            phoneController.text.isEmpty ||
            createPasswordController.text.isEmpty ||
            confirmPasswordController.text.isEmpty ||
            _uploadedImageUrl == null ||
            dropdownValue == list.first) {
          // แสดงข้อความแจ้งเตือน
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please complete all fields before proceeding!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
        if (createPasswordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Passwords do not match!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // ถ้าผ่านการตรวจสอบทั้งหมด ให้ไปยังหน้าถัดไป
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BankAccount(
              username: usernameController.text,
              email: emaiController.text,
              phone: phoneController.text,
              createPassword: createPasswordController.text,
              confirmPassword: confirmPasswordController.text,
              gender: dropdownValue.toLowerCase(),
              cusCardImagePath: _uploadedImageUrl,
            ),
          ),
          (Route<dynamic> route) => false,
        );
        debugPrint("Username : ${usernameController.text}");
        debugPrint("Emai : ${emaiController.text}");
        debugPrint("Phone : ${phoneController.text}");
        debugPrint("Create Password : ${createPasswordController.text}");
        debugPrint("Confirm Password : ${confirmPasswordController.text}");
        debugPrint("Gender: ${dropdownValue.toLowerCase()}");
        debugPrint(_uploadedImageUrl);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 34),
        foregroundColor: Colors.blue,
        backgroundColor: const Color(0xff1a1c43),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 6),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Next",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _snackBarnotification() {
    if (usernameController.text == "" &&
        emaiController.text == "" &&
        phoneController.text == "" &&
        createPasswordController.text == "" &&
        confirmPasswordController.text == "" &&
        dropdownValue == "Gender") {
      return Container(
        padding: const EdgeInsets.all(8),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent)),
        child: const Row(
          children: [
            SizedBox(
              width: 48,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Oh snap!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff1a1c43),
                    ),
                  ),
                  Text(
                    "Username or Password is Wrong",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff1a1c43),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
