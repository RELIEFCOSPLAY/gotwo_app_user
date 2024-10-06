import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/m2/bank.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  final Map<String, dynamic> data;
  const Register({Key? key, required this.data}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Uint8List? _image;
  late Map<String, dynamic> item;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Color(0xff1a1c43)),
  );
  String? emails;
  String? userId;

  final storage = const FlutterSecureStorage();

  Future<void> loadLoginInfo() async {
    String? savedEmail = await storage.read(key: 'email');
    setState(() {
      emails = savedEmail;
    });
    if (emails != null) {
      fetchUserId(emails!);
    }
  }

  Future<void> fetchUserId(String email) async {
    final String url = "http://10.0.2.2:80/gotwo/getUserId.php"; // API URL
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            userId = data['user_id'];
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print("Failed to fetch user ID");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final url = Uri.parse('http://10.0.2.2:80/gotwo/regis.php');

  // Updated update_review function
  Future<void> update_regis(
    String regis_customer_id,
    // String img_profile,
    String name,
    String email,
    String tel,
    String gender,
    String password,
    // String img_id_card,
    String bank,
    String name_account,
    String number_bank,
    String status_customer,
  ) async {
    try {
      var request = await http.post(url, body: {
        "regis_customer_id": regis_customer_id,
        // "img_profile": img_profile,
        'name': name,
        'email': email,
        'tel': tel,
        'gender': gender,
        'password': password,
        // 'img_id_card': img_id_card,
        'bank': bank,
        'name_account': name_account,
        'number_bank': number_bank,
        'status_customer': status_customer,
      });

      if (request.statusCode == 200) {
        // Data sent successfully
        print('Success: ${request.body}');
        print('Customer ID: $regis_customer_id');
      } else {
        // There was a problem sending data
        print('Error: ${request.statusCode}, Body: ${request.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void selectImage() async {
    Uint8List? imageBytes = await pickImage(ImageSource.gallery);
    if (imageBytes != null) {
      setState(() {
        _image = imageBytes;
      });
    } else {
      debugPrint('No image selected');
    }
  }

  @override
  void initState() {
    super.initState();
    item = widget.data;
    loadLoginInfo();
  }

  // Dropdown items
  List<String> _items = ['Female', 'Male'];
  String? selectedItem;

  // Controllers for TextFields
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController name_accountController = TextEditingController();
  TextEditingController number_bankController = TextEditingController();

  // Widget build
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Color(0xFF1A1C43),
          ),
        ),
        backgroundColor: Colors.transparent, // กำหนดสีของ AppBar เป็นโปร่งใส
        elevation: 0, // ไม่มีเงาใต้ AppBar
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // ใช้ไอคอนแบ็กสีดำ
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_image != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(_image!),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: telController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Gender"),
                        value: selectedItem,
                        items: _items.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedItem = value;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passController,
                      obscureText: true, // ซ่อนรหัส
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Create Password',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: confirmPassController,
                      obscureText: true, // ซ่อนรหัส
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String? regis_customer_id = userId;
                    String name = nameController.text;
                    String email = emailController.text;
                    String tel = telController.text;
                    String gender = selectedItem ?? '';
                    String password = passController.text;
                    String confirmPassword = confirmPassController.text;
                    String bank = selectedItem ?? '';
                    String name_account = name_accountController.text;
                    String number_bank = number_bankController.text;
                    // String status_customer = '1';
                    // // ตรวจสอบรหัสผ่านและยืนยันรหัสผ่าน
                    // if (password != confirmPassword) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //         content: Text(
                    //             'Password and confirm password do not match')),
                    //   );
                    //   return;
                    // }

                    // // ตรวจสอบว่าได้เลือกรูปภาพหรือยัง
                    // if (_image == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //         content: TeFxt('Please select an image')),
                    //   );
                    //   return;
                    // }

                    update_regis(
                      regis_customer_id!,
                      name,
                      email,
                      tel,
                      gender,
                      password,
                      confirmPassword,
                      // 'img_id_card_placeholder', // Placeholder สำหรับบัตรประชาชน
                      bank, // Placeholder สำหรับธนาคาร
                      name_account, 
                      number_bank, // Placeholder สำหรับชื่อบัญชี
                      // 'number_bank_placeholder', // Placeholder สำหรับเลขบัญชี
                     
                    );
                    print(regis_customer_id!);
                    print(name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BankAccount()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF1A1C43)), // background color
                    minimumSize: MaterialStateProperty.all(
                        const Size(110, 35)), // Set minimum size here
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  try {
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
  }
  return null;
}
