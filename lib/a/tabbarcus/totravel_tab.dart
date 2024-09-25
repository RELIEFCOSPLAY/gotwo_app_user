import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/cus_totravel.dart';
import 'package:http/http.dart' as http;

class TotravelTab extends StatefulWidget {
  @override
  State<TotravelTab> createState() => _TotravelTabState();
}

class _TotravelTabState extends State<TotravelTab> {
  List<dynamic> testDate = []; // สร้าง List สำหรับเก็บข้อมูลที่ดึงมา

  @override
  void initState() {
    super.initState();
    fetchTravelData(); // เรียกใช้ฟังก์ชันเมื่อเริ่มต้น
  }

  Future<void> fetchTravelData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://10.0.2.2:80/gotwo/status_pending.php")); // URL API

      if (response.statusCode == 200) {
        setState(() {
          testDate = json.decode(response.body); // แปลง JSON เป็น List
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: $e"); // แสดงข้อผิดพลาดใน console
    }
  }

  String getStatusLabel(String pay) {
    int payCode = int.tryParse(pay) ?? -1; // แปลงเป็น int หรือคืนค่า -1 หากแปลงไม่สำเร็จ
    return payCode == 0 ? "Unaid" : (payCode == 1 ? "Paid" : "Unknown"); // ตรวจสอบสถานะ
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TotravelTab(),
      ],
    );
  }

  Widget _TotravelTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 320,
        height: 444,
        child: ListView.builder(
          itemCount: testDate.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
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
                            'rider_id': testDate[index]['rider_id'],
                            'gender': testDate[index]['rider_gender'],
                            'date': testDate[index]['date'],
                            'price': testDate[index]['price'],
                            'pick_up': testDate[index]['pick_up'],
                            'comment_pick': testDate[index]['comment_pick'],
                            'at_drop': testDate[index]['at_drop'],
                            'comment_drop': testDate[index]['comment_drop'],
                            'status_helmet': testDate[index]['status_helmet'],
                            'pay': testDate[index]['pay'],
                            'rider_tel': testDate[index]['rider_tel'],
                          },
                        ),
                      ),
                    );
                    debugPrint("CardRequest ${testDate[index]['pick_up']}");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xfffbf8ff)),
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
                                  "From: ${testDate[index]['pick_up']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xff1a1c43)),
                                ),
                              ],
                            ),
                            Text(
                              "Date: ${testDate[index]['date']} ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff1a1c43)),
                            ),
                            Text(
                              "Time: ${testDate[index]['time']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff1a1c43)),
                            ),
                            Text(
                              "Status: ${getStatusLabel(testDate[index]['pay'])}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff1a1c43)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, color: Color(0xff1a1c43)),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.tour, color: Color(0xff1a1c43), size: 20.0),
                                const SizedBox(width: 5),
                                Text(
                                  "To: ${testDate[index]['at_drop']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xff1a1c43)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${testDate[index]['price']} ",
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
          },
        ),
      ),
    );
  }
}
