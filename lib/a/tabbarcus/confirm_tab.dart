import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/cus_confirm1.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:gotwo_app_user/m2/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmTab extends StatefulWidget {
  @override
  State<ConfirmTab> createState() => _ConfirmTabState();
}

class _ConfirmTabState extends State<ConfirmTab> {
  List<dynamic> travelData = []; // สร้าง List สำหรับเก็บข้อมูลที่ดึงมา
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
    fetchData(); // Call fetchData() on init
    loadLoginInfo();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://${Global.ip_8080}/gotwo/status_pending.php")); // URL API

      if (response.statusCode == 200) {
        setState(() {
          travelData = json.decode(response.body);
        });
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String getStatusLabel(String pay) {
    int payCode =
        int.tryParse(pay) ?? -1; // แปลงเป็น int หรือคืนค่า -1 หากแปลงไม่สำเร็จ
    return payCode == 0
        ? "Unaid"
        : (payCode == 1 ? "Paid" : "Unknown"); // ตรวจสอบสถานะ
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 320,
        height: 444,
        child: ListView.builder(
          itemCount: travelData.length,
          itemBuilder: (context, index) {
            final item = travelData[index];
            
            if (userId == item['customer_id'].toString() &&
                item['status'].toString() == "confirm") {
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                child: SizedBox(
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CusConfirm(
                                  data: {
                                    'rider_id': travelData[index]['rider_id'],
                                    'gender': travelData[index]['rider_gender'],
                                    'date': travelData[index]['date'],
                                    'price': travelData[index]['price'],
                                    'pick_up': travelData[index]['pick_up'],
                                    'comment_pick': travelData[index]
                                        ['comment_pick'],
                                    'at_drop': travelData[index]['at_drop'],
                                    'comment_drop': travelData[index]
                                        ['comment_drop'],
                                    'status_helmet': travelData[index]
                                        ['status_helmet'],
                                    'pay': travelData[index]['pay'],
                                  },
                                )),
                      );
                      debugPrint("CardRequest ${travelData[index]['pick_up']}");
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xfffbf8ff)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Color(0xff1a1c43)),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "From: ${travelData[index]['pick_up']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xff1a1c43)),
                                  ),
                                ],
                              ),
                              Text(
                                "Date: ${travelData[index]['date']}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff1a1c43)),
                              ),
                              Text(
                                "Time: ${travelData[index]['time']}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff1a1c43)),
                              ),
                              Text(
                                "Status: ${getStatusLabel(travelData[index]['pay'])}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff1a1c43)),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward,
                              color: Color(0xff1a1c43)),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.tour,
                                      color: Color(0xff1a1c43), size: 20.0),
                                  const SizedBox(width: 5),
                                  Text(
                                    "To: ${travelData[index]['at_drop']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xff1a1c43)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${travelData[index]['price']} ",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xff1a1c43)),
                                  ),
                                  const Text(
                                    "THB",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xff1a1c43)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink(); // ไม่แสดงอะไรถ้าไม่ตรงกัน
            }
          },
        ),
      ),
    );
  }
}
