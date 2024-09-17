import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/m2/login.dart';  // import หน้า login ของคุณ

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  final storage = const FlutterSecureStorage();

  // ฟังก์ชันสำหรับ Logout
  Future<void> _logout() async {
    // ลบข้อมูลการเข้าสู่ระบบจาก secure storage
    await storage.deleteAll();
    // นำผู้ใช้กลับไปที่หน้า Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginpage()),
    );
  }

  @override
  void initState() {
    super.initState();
    // ทำการ logout ทันทีเมื่อเปิดหน้า logout
    _logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // แสดง indicator ระหว่างรอการ logout
      ),
    );
  }
}
