import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CusSuccess extends StatefulWidget {
  final Map<String, dynamic> data;
  const CusSuccess({Key? key, required this.data}) : super(key: key);

  @override
  State<CusSuccess> createState() => _CusSuccessState();
}

class _CusSuccessState extends State<CusSuccess> {
  late Map<String, dynamic> item;
  List<dynamic> succData = [];
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
      fetchUserId(emails!); // เรียกใช้ API เพื่อตรวจสอบ user id
    }
  }

  Future<void> fetchUserId(String email) async {
    final String url = "http://${Global.ip_80}/gotwo/getUserId_cus.php";  // URL API
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

  @override
  Widget build(BuildContext context) {
    int _currentRating = int.parse(item['review']);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Success',
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
            Navigator.pop(context);
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
                Image.asset(
                  item['image'] ?? 'assets/images/profile.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${item['gender']} ',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      (item['gender']?.toLowerCase() == 'male')
                          ? Icons.male
                          : Icons.female,
                      color: const Color(0xFF1A1C43),
                      size: 15,
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
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF1A1C43),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Date: ${formatDate(widget.data['date'])}",
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
                    const Icon(
                      Icons.payment,
                      color: Color(0xFF1A1C43),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${item['price']} THB',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  item['pay'] == '1' || item['pay'] == 1
                      ? "Paid"
                      : item['pay'] == '0' || item['pay'] == 0
                          ? "Unpaid"
                          : item['pay'] == '2' || item['pay'] == 2
                              ? "Refund"
                              : item['pay'] == '3' || item['pay'] == 3
                                  ? "Pending"
                                  : item['pay'] == '4' || item['pay'] == 4
                                      ? "Completed"
                                      : "Unknown", // กรณีที่ไม่ตรงกับเงื่อนไขใดๆ
                  style: TextStyle(
                    fontSize: 12,
                    color: item['pay'] == '1' || item['pay'] == 1
                        ? Colors.green // Green for "Paid"
                        : item['pay'] == '0' || item['pay'] == 0
                            ? Colors.red // Red for "Unpaid"
                            : item['pay'] == '2' || item['pay'] == 2
                                ? Colors.orange // Orange for "Refund"
                                : item['pay'] == '3' || item['pay'] == 3
                                    ? Colors.blue // Blue for "Pending"
                                    : item['pay'] == '4' || item['pay'] == 4
                                        ? Colors
                                            .green[300] // Grey for "Completed"
                                        : Colors.black, // Black for "Unknown"
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 180,
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
                        const SizedBox(height: 5),
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
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
