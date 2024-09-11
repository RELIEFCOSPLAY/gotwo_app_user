import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';

class Joindetail extends StatefulWidget {
  final Map<String, dynamic> item; // รับข้อมูลจากหน้าแรก

  const Joindetail({Key? key, required this.item}) : super(key: key);

  @override
  State<Joindetail> createState() => _JoindetailState();
}

class _JoindetailState extends State<Joindetail> {
  bool isLoading = true;
  Map<String, dynamic>? item;

  @override
  void initState() {
    super.initState();
    item = widget.item; // ใช้ข้อมูล item ที่ส่งมาจากหน้าแรก
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join',
          style: TextStyle(
            color: Color(0xFF1A1C43),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Image.network(
                    item!['image'] ?? 'https://your-default-image-url.com/default.png', // ใช้ Image.network สำหรับโหลดภาพจาก URL
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/profile.png', width: 50, height: 50); // ใช้ภาพเริ่มต้นในกรณีที่ไม่สามารถโหลดภาพได้
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item!['rider_id']} ',
                    style: const TextStyle(
                      color: Color(0xFF1A1C43),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item!['rider_gender'] == 'Male' ? Icons.male : Icons.female,
                        color: const Color(0xFF1A1C43),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${item!['rider_gender']} ',
                        style: const TextStyle(
                          color: Color(0xFF1A1C43),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.payment,
                        color: Color(0xFF1A1C43),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${item!['price']} THB',
                        style: const TextStyle(
                          color: Color(0xFF1A1C43),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF1A1C43),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Date: ${item!['date']}',
                        style: const TextStyle(
                          color: Color(0xFF1A1C43),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 270,
                    height: 215,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1, // Border width
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.my_location,
                              color: Colors.green,
                              size: 15,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${item!['pick_up']}',
                                style: const TextStyle(
                                  color: Color(0xFF1A1C43),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            '${item!['commpick']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Divider(
                            color: Color(0xFF1A1C43),
                            thickness: 1,
                            height: 0.5,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Drop',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              color: Color(0xFFD3261A),
                              size: 15,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${item!['at_drop']}',
                                style: const TextStyle(
                                  color: Color(0xFF1A1C43),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            '${item!['commdrop']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Divider(
                            color: Color(0xFF1A1C43),
                            thickness: 1,
                            height: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TabbarCus(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(90, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Join',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
