import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/join.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้านี้
          },
        ),
      ),
      body: SafeArea(
        child: Center(
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

              // textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey[200],
                    border: Border.all(color: const Color(0xFF1A1C43), width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFF1A1C43), width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding:EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: true, // ซ่อนนรหัส
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: () {  
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           const Join()), // ให้ NextPage() เป็นหน้าถัดไป
                    // );
                    },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF1A1C43)), //  background color
                    minimumSize: WidgetStateProperty.all(
                        const Size(110, 35)), // Set minimum size here
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
    );
  }
}
