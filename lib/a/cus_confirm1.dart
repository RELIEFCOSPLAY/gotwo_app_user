import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CusConfirm extends StatefulWidget {
  final Map<String, dynamic> data; // รับค่าที่ส่งมาจาก ConfirmTab

  const CusConfirm({Key? key, required this.data}) : super(key: key);

  @override
  State<CusConfirm> createState() => _CusConfirmState();
}

class _CusConfirmState extends State<CusConfirm> {
  List<dynamic> travelData = [];
  bool isPaid = false; // สถานะสำหรับเช็คการจ่ายเงิน
  bool isImageUploaded = false; // สถานะสำหรับเช็คว่ารูปถูกอัปโหลดหรือยัง

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
    loadLoginInfo();
  }
  final url = Uri.parse('http://10.0.2.2:80/gotwo/status_update.php');
  Future<void> update_pay(
    String customer_id,
    String pay,
  ) async {
    var request = await http.post(url, body: {
      "customer_id": customer_id,
      "pay": pay,
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

  void showQrCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: const Center(
              child: Text(
                'QR Code',
                textAlign: TextAlign.center,
              ),
            ),
            content: SizedBox(
              width: 200.0,
              height: 250.0,
              child: Column(
                children: [
                  QrImageView(
                    data: '${widget.data['price']}', // ข้อมูลสำหรับ QR Code
                    version: QrVersions.auto,
                    size: 220.0,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await uploadImage(File(image.path)); // อัปโหลดรูปภาพ
                    setState(() {
                      isImageUploaded = true; // อัปเดตสถานะเป็นรูปถูกอัปโหลด
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  minimumSize: const Size(15, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Attach Image',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> uploadImage(File imageFile) async {
    print('Uploading image: ${imageFile.path}');
    await Future.delayed(Duration(seconds: 2)); // จำลองเวลาในการอัปโหลด
    // ที่นี่คุณสามารถเพิ่มโค้ดเพื่ออัปโหลดรูปไปยังเซิร์ฟเวอร์จริงๆ ได้
  }

  Future<void> updatePaymentStatus() async {
    // ฟังก์ชันสำหรับการอัปเดตสถานะการชำระเงินไปยัง API
    final url = Uri.parse("http://10.0.2.2:80/gotwo/status_update.php");
    final response = await http.post(
      url,
      body: {
        'customer_id': widget.data['customer_id'],
        'pay': '1',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update payment status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm',
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
                Image.asset(
                  widget.data['image'] ?? 'assets/images/profile.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.data['rider_id']} ',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      (widget.data['gender']?.toLowerCase() == 'male')
                          ? Icons.male
                          : Icons.female,
                      color: const Color(0xFF1A1C43),
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rate ',
                      style: TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.star, color: Colors.yellow, size: 15),
                    Icon(Icons.star, color: Colors.yellow, size: 15),
                    Icon(Icons.star, color: Colors.yellow, size: 15),
                    Icon(Icons.star, color: Colors.yellow, size: 15),
                    Icon(Icons.star, color: Colors.yellow, size: 15),
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
                      '${widget.data['date']}',
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
                    const Icon(Icons.payment,
                        color: Color(0xFF1A1C43), size: 15),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.data['price']} THB',
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
                  height: 150,
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
                                '${widget.data['pick_up']}',
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
                            '${widget.data['comment_pick']}',
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
                                '${widget.data['at_drop']}',
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
                            '${widget.data['comment_drop']}',
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
                  widget.data['status_helmet'] == '0'
                      ? 'Bring your own a helmet.'
                      : 'There is a helmet for you.',
                  style: TextStyle(
                    color: widget.data['status_helmet'] == '0'
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
                    ElevatedButton(
                      onPressed: widget.data['pay'] == '1' || isPaid
                          ? null
                          : isImageUploaded
                              ? () async {
                                  setState(() {
                                    isPaid = true;
                                  });
                                  if (widget.data['pay'] == '1' ||
                                      isPaid == true) {
                                    String? customer_id = userId;
                                    String pay = '1';
                                    print(customer_id);

                                    update_pay(
                                      customer_id!,
                                      pay,
                                    );
                                  }
                                }
                              : () {
                                  showQrCodeDialog();
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.data['pay'] == '1' || isPaid
                            ? Colors.grey
                            : Colors.green,
                        minimumSize: const Size(90, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        isPaid ? 'OK' : 'Paid',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
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
