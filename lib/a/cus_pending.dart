import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CusPending extends StatefulWidget {
  final Map<String, dynamic> data; // รับค่าที่ส่งมาจาก ConfirmTab

  const CusPending({Key? key, required this.data}) : super(key: key);

  @override
  State<CusPending> createState() => _CusPendingState();
}

class _CusPendingState extends State<CusPending> {
  late Map<String, dynamic> item;
  List<dynamic> travelData = [];
  bool isPaid = false; // สถานะสำหรับเช็คการจ่ายเงิน
  bool isImageUploaded = false; // สถานะสำหรับเช็คว่ารูปถูกอัปโหลดหรือยัง

  final storage = const FlutterSecureStorage();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Color(0xff1a1c43)),
  );
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
    final String url = "http://${Global.ip_8080}/gotwo/getUserId_cus.php";
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
        print("Failed to fetch user id");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final url = Uri.parse('http://${Global.ip_8080}/gotwo/status_confirme.php');

  Future<void> update_cancel(
    String status_post_id,
    String comment,
    String pay,
    String status,
  ) async {
    var request = await http.post(url, body: {
      "status_post_id": status_post_id,
      'status': status,
      'comment': comment,
      "pay": pay,
    });
    if (request.statusCode == 200) {
      print('Success: ${request.body}');
      print('Id Be ${userId}');
    } else {
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

  Future<void> uploadImage(File imageFile) async {
    print('Uploading image: ${imageFile.path}');
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    item = widget.data;
    loadLoginInfo();
  }

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);

      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return "";
    }
  }

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int _currentRating = int.parse(item['review']);
    String imgShow = 'http://${Global.ip_8080}/${item['img_profile']}';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending',
          style: TextStyle(
            color: Color(0xFF1A1C43),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const TabbarCus()),
            );
          },
        ),
      ),
      body: SafeArea(
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
                  child: item['img_profile'] != null
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['gender'] == 'male'
                          ? Icons.male // Icon for Male
                          : item['gender'] == 'female'
                              ? Icons.female // Icon for Female
                              : Icons
                                  .help_outline, // Default icon if gender is unknown or other
                      color: item['gender'] == 'male'
                          ? Colors.blue
                          : item['gender'] == 'female'
                              ? Colors.pink
                              : Colors.grey,
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Text(
                      "${item['gender'] ?? 'Unknown'}",
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Rate",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    for (var i = 1; i <= 5; i++)
                      Icon(
                        Icons.star,
                        size: 12,
                        color:
                            i <= _currentRating ? Colors.yellow : Colors.grey,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFF1A1C43), size: 15),
                    const SizedBox(width: 5),
                    Text(
                      "Date: ${formatDate(item['date'])}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff1a1c43),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment,
                        color: Color(0xFF1A1C43), size: 15),
                    const SizedBox(width: 5),
                    Text(
                      '${item['price']} THB',
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
                  width: 300,
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Pickup',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.my_location,
                                color: Colors.green, size: 18),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${item['pick_up']}',
                                style: const TextStyle(
                                  color: Color(0xFF1A1C43),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            '${item['comment_pick']}',
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
                              thickness: 0.5,
                              height: 1),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Drop',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.pin_drop,
                                color: Color(0xFFD3261A), size: 18),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${item['at_drop']}',
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
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            '${item['comment_drop']}',
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
                              thickness: 0.5,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  item['status_helmet'] == '0'
                      ? 'Bring your own a helmet.'
                      : 'There is a helmet for you.',
                  style: TextStyle(
                    color: item['status_helmet'] == '0'
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Why did you cancel?',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              content: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: SizedBox(
                                  width: 270,
                                  height: 60,
                                  child: TextField(
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      enabledBorder: border,
                                      focusedBorder: border,
                                      border: const OutlineInputBorder(),
                                      hintText: 'What is your opinion?',
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    String status = "5";
                                    String pay = "0"; // กำหนดค่าเริ่มต้น
                                    if (item['pay'].toString() == "1" ||
                                        item['pay'] == 1 ||
                                        item['pay'].toString() == "2" ||
                                        item['pay'] == 2) {
                                      pay = "4";
                                    } else if (item['pay'].toString() == "0" ||
                                        item['pay'] == 0) {
                                      pay = "6";
                                    }
                                    String post_id = item['post_id'];
                                    String checkstatus = '0';
                                    String cancelReason =
                                        commentController.text;
                                    String status_post_id =
                                        '${item['status_post_id'] ?? 'Unknown'}';

                                    update_cancel(status_post_id, cancelReason,
                                        pay, status);
                                    check_status(
                                      checkstatus,
                                      post_id,
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TabbarCus(),
                                      ),
                                    );
                                  },
                                  child: const Text('OK',
                                      style: TextStyle(color: Colors.green)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(90, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
