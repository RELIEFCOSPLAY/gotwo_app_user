import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CusCancel extends StatefulWidget {
  final Map<String, dynamic> data;
  const CusCancel({Key? key, required this.data}) : super(key: key);

  @override
  State<CusCancel> createState() => _CusCancelState();
}

class _CusCancelState extends State<CusCancel> {
  late Map<String, dynamic> item;
  List<dynamic> cancelData = [];
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
    String imgShow = 'http://${Global.ip_8080}/${item['img_profile']}';
    String imgMoneyslip = 'http://${Global.ip_8080}/${item['img_qr_admin']}';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cancel',
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
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['pay'] == '0'
                          ? "Unpaid"
                          : item['pay'] == '1'
                              ? "Paid"
                              : item['pay'] == '2'
                                  ? "Verify"
                                  : item['pay'] == '3'
                                      ? "Pending"
                                      : item['pay'] == '4'
                                          ? "Refund"
                                          : item['pay'] == '5'
                                              ? "Complete"
                                              : item['pay'] == '6'
                                                  ? "Cancel"
                                                  : "Unknown", // กรณีที่ไม่ตรงกับเงื่อนไขใดๆ
                      style: TextStyle(
                        fontSize: 12,
                        color: item['pay'] == '0'
                            ? Colors.red // Red for "Unpaid"
                            : item['pay'] == '1'
                                ? Colors.green // Green for "Paid"
                                : item['pay'] == '2'
                                    ? Colors
                                        .green[200] // Green[200] for "Verify"
                                    : item['pay'] == '3'
                                        ? Colors.blue // Blue for "Pending"
                                        : item['pay'] == '4'
                                            ? Colors
                                                .orange // orange for "Refund"
                                            : item['pay'] == '5'
                                                ? Colors.blue[
                                                    200] // Blue[200] for "Complete"
                                                : item['pay'] == '6'
                                                    ? Colors.red[
                                                        400] //Red[400] for "Cancel"
                                                    : Colors
                                                        .grey, // Grey for "Unknown"
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            title: const Center(
                              child: Text(
                                'Money slip',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            content: SizedBox(
                              width: 200.0,
                              height: 250.0,
                              child: item['img_qr_admin'] != null &&
                                      item['img_qr_admin'].trim().isNotEmpty
                                  ? Image.network(
                                      imgMoneyslip,
                                      fit: BoxFit
                                          .cover, // ปรับให้รูปภาพเติมเต็มพื้นที่
                                      width: 200, // กำหนดขนาดความกว้าง
                                      height: 200, // กำหนดขนาดความสูง
                                    )
                                  : const Icon(Icons.person),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1C43),
                    minimumSize: const Size(5, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Money slip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                // const SizedBox(height: 5),
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
                const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       'Rate ',
                //       style: TextStyle(
                //         color: Color(0xFF1A1C43),
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15,
                //       ),
                //     ),
                //     const SizedBox(width: 5),
                //     RatingBarIndicator(
                //       rating: double.parse(
                //           item['review'] ?? '0'),
                //       itemBuilder: (context, index) => const Icon(
                //         Icons.star,
                //         color: Colors.yellow,
                //       ),
                //       itemCount: 5,
                //       itemSize: 15.0,
                //       direction: Axis.horizontal,
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason',
                        style: TextStyle(
                          color: Color(0xFF1A1C43),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          '${item['comment']}',
                          textAlign: TextAlign.left, // จัดข้อความให้อยู่ทางซ้าย
                          style: const TextStyle(
                            color: Color(0xFF1A1C43),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
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
  }
}
