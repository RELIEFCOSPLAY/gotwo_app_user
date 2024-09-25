import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/m2/join.dart';
import 'package:http/http.dart' as http;

class Joindetail extends StatefulWidget {
  final Map<String, dynamic> item; // รับข้อมูลจากหน้าแรก

  const Joindetail({Key? key, required this.item}) : super(key: key);

  @override
  State<Joindetail> createState() => _JoindetailState();
}

class _JoindetailState extends State<Joindetail> {
  bool isLoading = true;
  Map<String, dynamic>? item;

  final storage = const FlutterSecureStorage();
  String? emails;
  String? userId; // เก็บ ID ของผู้ใช้หลังจากดึงมา

  Future<void> loadLoginInfo() async {
    String? savedEmail = await storage.read(key: 'email');
    setState(() {
      emails = savedEmail;
    });
    if (emails != null) {
      fetchUserId(emails!); // เรียกใช้ API เพื่อตรวจสอบ user id
    }
  }


  Future<void> fetchUserId(String email) async {
    final String url =
        "http://10.0.2.2:80/gotwo/getUserId.php"; // URL API
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email, // ส่ง email เพื่อค้นหา user id
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            userId = data['user_id']; // เก็บ user id ที่ได้มา
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print("Failed to fetch user id");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    item = widget.item; // ใช้ข้อมูล item ที่ส่งมาจากหน้าแรก
    print(item); // พิมพ์ข้อมูล item ออกมาเพื่อตรวจสอบ
    isLoading = false;
    loadLoginInfo();
  }

  final url =
      Uri.parse('http://10.0.2.2:80/gotwo/join_post_customer.php');
  Future<void> join_post(
      String status,
      String reason,
      String post_id,
      String customer_id,
      String pay,
      String review,
      String comment,
      String rider_id) async {
    var request = await http.post(url, body: {
      "status": status,
      "reason": reason,
      "post_id": post_id,
      "customer_id": customer_id,
      "pay": pay,
      "review": review,
      "comment": comment,
      "rider_id": rider_id,
    });

    if (request.statusCode == 200) {
      // ข้อมูลถูกส่งสำเร็จ
      print('Success: ${request.body}');
      print('Id Be ${userId}');
    } else {
      // มีปัญหาในการส่งข้อมูล
      print('Error: ${request.statusCode}, Body: ${request.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
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
                    item!['image'] ??
                        'https://your-default-image-url.com/default.png', // ใช้ Image.network สำหรับโหลดภาพจาก URL
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/profile.png',
                          width: 50,
                          height:
                              50); // ใช้ภาพเริ่มต้นในกรณีที่ไม่สามารถโหลดภาพได้
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item!['rider_name']} ',
                    style: const TextStyle(
                      color: Color(0xFF1A1C43),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item!['rider_gender'] == 'Male'
                            ? Icons.male
                            : Icons.female,
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
                    height: 225,
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
                        const SizedBox(height: 3),
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
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 3),
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      String status = 'required';
                      String reason = 'wait to long';
                      String post_id = item!['post_id'];
                      String? customer_id = userId;
                      String pay = '0';
                      String review = '0';
                      String comment = 'cancel';
                      String rider_id = item!['rider_id'];

                      join_post(
                        status,
                        reason,
                        post_id,
                        customer_id!,
                        pay,
                        review,
                        comment,
                        rider_id,
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Join(),
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
