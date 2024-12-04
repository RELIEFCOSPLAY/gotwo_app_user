import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/global_ip.dart';
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
  String? avgReview;
  int? rating;

  Future<void> fetchAVGRating(String riderid) async {
    final String url =
        "http://${Global.ip_8080}/gotwo/avg_RiderRating.php"; // URL API
    try {
      final response = await http.post(Uri.parse(url), body: {
        'userid': riderid, // ส่ง user id เพื่อค้นหา avg
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            avgReview = data['avg_review'].toString();
            // พยายามแปลงเป็น int
            try {
              double avgReviewDouble = double.parse(avgReview!);
              rating = avgReviewDouble.toInt();
            } catch (e) {
              print('Error: Unable to parse avg_review to int.');
              rating = 0; // กำหนดค่าเริ่มต้น
            }
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print("Failed to fetch avg review");
      }
    } catch (e) {
      print("F Error: $e");
    }
  }

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
        "http://${Global.ip_8080}/gotwo/getUserId_cus.php"; // URL API
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email, // ส่ง email เพื่อค้นหา user id
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            userId = data['user_id']; // เก็บ user id ที่ได้มา
            fetchAVGRating(item!['rider_id']);
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
      Uri.parse('http://${Global.ip_8080}/gotwo/join_post_customer.php');
  Future<void> join_post(
    String status,
    String reason,
    String post_id,
    String customer_id,
    String pay,
    String review,
    String comment,
    String rider_id,
  ) async {
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

  final url_check_status =
      Uri.parse('http://${Global.ip_8080}/gotwo/check_status.php');
  Future<void> check_status(
    String check_status,
    String post_id,
  ) async {
    var request = await http.post(url_check_status, body: {
      "check_status": check_status,
      "post_id": post_id,
    });

    if (request.statusCode == 200) {
      // ข้อมูลถูกส่งสำเร็จ
      print('Success: ${request.body}');
    } else {
      // มีปัญหาในการส่งข้อมูล
      print('Error: ${request.statusCode}, Body: ${request.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String imgShow = 'http://${Global.ip_8080}/${item!['img_profile']}';
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
                  CircleAvatar(
                    minRadius: 25,
                    maxRadius: 40,
                    backgroundColor: Colors.white,
                    child: item!['img_profile'] != null
                        ? ClipOval(
                            // ใช้ ClipOval เพื่อครอบภาพให้เป็นวงกลม
                            child: Image.network(
                              imgShow,
                              fit: BoxFit.cover, // ปรับให้รูปภาพเติมเต็มพื้นที่
                              width: 80, // กำหนดขนาดความกว้าง
                              height: 80, // กำหนดขนาดความสูง
                            ),
                          )
                        : const Icon(Icons.person),
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
                      for (var i = 1; i <= 5; i++)
                        Icon(
                          Icons.star,
                          size: 20,
                          color: i <=
                                  (rating ??
                                      0) // ใช้ ?? เพื่อกำหนดค่าเริ่มต้นหาก rating เป็น null
                              ? Colors.yellow
                              : Colors.grey,
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item!['rider_gender'] == 'male'
                                ? Icons.male // Icon for Male
                                : item!['rider_gender'] == 'female'
                                    ? Icons.female // Icon for Female
                                    : Icons
                                        .help_outline, // Default icon if gender is unknown or other
                            color: item!['rider_gender'] == 'male'
                                ? Colors.blue
                                : item!['rider_gender'] == 'female'
                                    ? Colors.pink
                                    : Colors.grey,
                          ),
                          const SizedBox(
                              width: 5), // Space between icon and text
                          Text(
                            "${item!['rider_gender'] ?? 'Unknown'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showDialog();
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

  Future<void> _showDialog() async {
    final item = widget.item;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join'),
          content: const Text('Are you sure to join?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String status = '1';
                    String reason = 'wait to long';
                    String post_id = item['post_id'];
                    String? customer_id = userId;
                    String pay = '0';
                    String review = '0';
                    String comment = 'cancel';
                    String rider_id = item['rider_id'];
                    String checkstatus = '1';
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
                    check_status(
                      checkstatus,
                      post_id,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      )),
                  child:
                      const Text("Yes", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      )),
                  child:
                      const Text("back", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
