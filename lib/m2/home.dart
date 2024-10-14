import 'package:flutter/material.dart';
import 'package:gotwo_app_user/m2/login.dart';
// import 'package:gotwo_app_user/m/login.dart';
// import 'package:gotwo_app_user/m/register.dart';
// import 'package:flutter_application_1/m/login.dart';
// import 'package:flutter_application_1/m/register.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override ///////
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C43),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.jpg"),
              const SizedBox(
                height: 5,
              ),

              const Text(
                "GOTWO",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color(0xFFCCCCCC)),
              ),
              const Text(
                "Ride sharing service",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFE4E4EB),
                ),
              ),
              const SizedBox(height: 20),

              // พื้นหลัง
              Center(
                child: Container(
                  width: 270,
                  height: 200,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color:const Color(0x7E68687D), // สีพื้นหลังของ Container
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // button
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างของกรอบ
                          border: Border.all(
                            color: const Color(0xFFCCCCCC), // สีขอบ
                            width: 2, // ความหนาของเส้น
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Loginpage()), // ให้ NextPage() เป็นหน้าถัดไป
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF1A1C43),
                              // สีพื้นหลังของปุ่ม
                            ),
                            minimumSize: WidgetStateProperty.all(
                              const Size(180, 50),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างของกรอบ
                          border: Border.all(
                            color: Colors.black, // สีขอบ
                            width: 2, // ความหนาของเส้น
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //            Register()), // ให้ NextPage() เป็นหน้าถัดไป
                            // );
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.transparent, // สีพื้นหลังของปุ่ม
                            ),
                            minimumSize: WidgetStateProperty.all(
                              const Size(180, 50), // กำหนดขนาดของปุ่ม
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "By gotwo ride sharing service",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

