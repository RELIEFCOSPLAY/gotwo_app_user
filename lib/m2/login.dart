import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/m2/join.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import secure storage

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool rememberMe = false; // Remember Me option

  // ฟังก์ชันสำหรับบันทึกข้อมูลเข้าสู่ระบบ
  Future<void> saveLoginInfo() async {
    if (rememberMe) {
      await storage.write(key: 'email', value: email.text);
      await storage.write(key: 'password', value: pass.text);
      await storage.write(
          key: 'isLoggedIn', value: 'true'); // บันทึกสถานะการเข้าสู่ระบบ
    } else {
      await storage.deleteAll(); // ลบข้อมูลการเข้าสู่ระบบ
    }
  }

  // ฟังก์ชันสำหรับโหลดข้อมูลเข้าสู่ระบบ
  Future<void> loadLoginInfo() async {
    String? savedEmail = await storage.read(key: 'email');
    String? savedPassword = await storage.read(key: 'password');
    String? isLoggedIn = await storage.read(key: 'isLoggedIn');

    // ถ้ามีข้อมูลบันทึกไว้ และผู้ใช้เคย login ให้ข้ามไปหน้า Join
    if (isLoggedIn == 'true' && savedEmail != null && savedPassword != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Join()),
      );
    }
  }

  // ฟังก์ชันสำหรับเข้าสู่ระบบ
  Future<void> signIn() async {
    String url = "http://192.168.110.212:80/gotwo/signin.php";
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email.text,
        'password': pass.text,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "Error") {
          // ไม่พบผู้ใช้
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid login credentials.')),
          );
        } else {
          await saveLoginInfo(); // บันทึกข้อมูลการเข้าสู่ระบบ
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Join()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadLoginInfo(); // ตรวจสอบว่ามีการบันทึกข้อมูลการเข้าสู่ระบบหรือไม่
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้านี้
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/logo.jpg"),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color(0xFF1A1C43),
                  ),
                ),
                const SizedBox(height: 30),

                // Email textformfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF1A1C43), width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password textformfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF1A1C43), width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: pass,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Checkbox for "Remember Me"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text("Remember Me")
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Login button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await signIn();
                        debugPrint("Login ");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF1A1C43)),
                      minimumSize: WidgetStateProperty.all(const Size(110, 35)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
