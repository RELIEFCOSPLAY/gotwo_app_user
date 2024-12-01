import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/cus_totravel.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TotravelTab extends StatefulWidget {
  @override
  State<TotravelTab> createState() => _TotravelTabState();
}

class _TotravelTabState extends State<TotravelTab> {
  List<dynamic> testData = []; // สร้าง List สำหรับเก็บข้อมูลที่ดึงมา

  bool isLoading = true;
  Map<String, dynamic>? item;

  final storage = const FlutterSecureStorage();
  String? emails;
  String? userId;
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

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse("http://${Global.ip_8080}/gotwo/status_pending.php"));

      if (response.statusCode == 200) {
        setState(() {
          testData = json.decode(response.body);
          testData.sort((a, b) {
            // รวม date และ time เพื่อเปรียบเทียบ
            DateTime dateTimeA = DateTime.parse('${a['date']} ${a['time']}');
            DateTime dateTimeB = DateTime.parse('${b['date']} ${b['time']}');
            return dateTimeB.compareTo(dateTimeA);
          });
        });
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    loadLoginInfo();
  }

  String getStatusLabel(String pay) {
    int payCode = int.tryParse(pay) ?? -1;
    return payCode == 1 ? "Paid" : "";
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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 320,
        height: 444,
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchData(); // ดึงข้อมูลใหม่จากเซิร์ฟเวอร์
          },
          color: const Color(0xff1a1c43), // สีของวงกลม Refresh
          backgroundColor: Colors.white, // สีพื้นหลังของ RefreshIndicator
          child: ListView.builder(
            itemCount: testData.length,
            itemBuilder: (context, index) {
              final item = testData[index];
              if (userId == item['customer_id'].toString() &&
                  item['status'].toString() == "3") {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 8),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CusTotravel(
                              data: {
                                'status_post_id': item['status_post_id'],
                                'rider_id': item['rider_id'],
                                'img_profile': item['img_profile'],
                                'img_car_picture': item['img_car_picture'],
                                'gender': item['rider_gender'],
                                'date': item['date'],
                                'price': item['price'],
                                'pick_up': item['pick_up'],
                                'comment_pick': item['comment_pick'],
                                'at_drop': item['at_drop'],
                                'comment_drop': item['comment_drop'],
                                'status_helmet': item['status_helmet'],
                                'pay': item['pay'],
                                'rider_tel': item['rider_tel'],
                                'review': item['review'],
                                'post_id': item['post_id'],
                                'check_status': item['check_status'],
                              },
                            ),
                          ),
                        );
                        debugPrint("CardRequest ${item['pick_up']}");
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xfffbf8ff)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Color(0xff1a1c43)),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "From: ${item['pick_up']}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff1a1c43),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Date: ${formatDate(item['date'])}",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xff1a1c43)),
                                  ),
                                  Text(
                                    "Time: ${item['time']}",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xff1a1c43)),
                                  ),
                                  Text(
                                    item['pay'] == '1' || item['pay'] == 1
                                        ? "Paid"
                                        : item['pay'] == '0' || item['pay'] == 0
                                            ? "Unpaid"
                                            : item['pay'] == '2' ||
                                                    item['pay'] == 2
                                                ? "Refund"
                                                : item['pay'] == '3' ||
                                                        item['pay'] == 3
                                                    ? "Pending"
                                                    : item['pay'] == '4' ||
                                                            item['pay'] == 4
                                                        ? "Completed"
                                                        : "Unknown", // กรณีที่ไม่ตรงกับเงื่อนไขใดๆ
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: item['pay'] == '1' ||
                                              item['pay'] == 1
                                          ? Colors.green // Green for "Paid"
                                          : item['pay'] == '0' ||
                                                  item['pay'] == 0
                                              ? Colors.red // Red for "Unpaid"
                                              : item['pay'] == '2' ||
                                                      item['pay'] == 2
                                                  ? Colors
                                                      .orange // Orange for "Refund"
                                                  : item['pay'] == '3' ||
                                                          item['pay'] == 3
                                                      ? Colors
                                                          .blue // Blue for "Pending"
                                                      : item['pay'] == '4' ||
                                                              item['pay'] == 4
                                                          ? Colors.green[
                                                              300] // Grey for "Completed"
                                                          : Colors
                                                              .black, // Black for "Unknown"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward,
                                color: Color(0xff1a1c43)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.tour,
                                          color: Color(0xff1a1c43), size: 17.0),
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          "To: ${item['at_drop']}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff1a1c43)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${item['price']} ",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff1a1c43)),
                                      ),
                                      const Text(
                                        "THB",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff1a1c43)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // Return SizedBox.shrink() เมื่อไม่ตรงตามเงื่อนไข
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
