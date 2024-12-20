import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class CusConfirm extends StatefulWidget {
  final Map<String, dynamic> data; // รับค่าที่ส่งมาจาก ConfirmTab

  const CusConfirm({Key? key, required this.data}) : super(key: key);

  @override
  State<CusConfirm> createState() => _CusConfirmState();
}

class _CusConfirmState extends State<CusConfirm> {
  String? qr_pay;
  late Map<String, dynamic> item;
  List<dynamic> travelData = [];
  bool isPaid = false; // สถานะสำหรับเช็คการจ่ายเงิน
  bool isImageUploaded = false; // สถานะสำหรับเช็คว่ารูปถูกอัปโหลดหรือยัง
  TextEditingController commentController = TextEditingController();

  final storage = const FlutterSecureStorage();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Color(0xff1a1c43)),
  );
  String? emails;
  String? userId; // เก็บ ID ของผู้ใช้หลังจากดึงมา
  // เก็บ qr

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
    final String url = "http://${Global.ip_80}/gotwo/getUserId_cus.php";
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
  Future<void> update_pay(
    String status_post_id,
    String pay,
    String status,
  ) async {
    String comment = "No comment";
    var request = await http.post(url, body: {
      "status_post_id": status_post_id,
      "pay": pay,
      'comment': comment,
      'status': status,
    });
    if (request.statusCode == 200) {
      print('Success: ${request.body}');
    } else {
      print('Error: ${request.statusCode}, Body: ${request.body}');
    }
  }

  Future<void> update_cancel(
    String status_post_id,
    String pay,
    String comment,
    String status,
  ) async {
    var request = await http.post(url, body: {
      "status_post_id": status_post_id,
      "pay": pay,
      'comment': comment,
      'status': status,
    });
    if (request.statusCode == 200) {
      print('Success: ${request.body}');
    } else {
      print('Error: ${request.statusCode}, Body: ${request.body}');
    }
  }

  final url_check_status =
      Uri.parse('http://${Global.ip_80}/gotwo/check_status.php');
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

  final url_qr = Uri.parse('http://${Global.ip_8080}/gotwo/qr_gre.php');

  Future<void> qrCode_view(String price, String promptPay) async {
    try {
      var request = await http.post(url_qr, body: {
        "action": "PAY",
        "price": price,
        "promptPay": promptPay,
      });

      if (request.statusCode == 200) {
        final responseData = json.decode(request.body);

        if (responseData['status'] == 'success') {
          setState(() {
            qr_pay = responseData['qr_code'];
          });
          print("QR Code base64: $qr_pay");
          showQrCodeDialog();
        } else {
          print('Error: ${responseData['message']}');
        }
      } else {
        print('Error: ${request.statusCode}, Body: ${request.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  File? _image; // เก็บภาพที่เลือก
  String? _uploadedImageUrl; // เก็บ URL รูปภาพที่อัปโหลด

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // เปลี่ยนชื่อไฟล์เป็น "GP_timestamp"
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final directory = await getTemporaryDirectory();
      final newFileName = "GUQRP_$timestamp${path.extension(pickedFile.path)}";
      final newFilePath = path.join(directory.path, newFileName);

      final renamedFile = await File(pickedFile.path).copy(newFilePath);

      setState(() {
        _image = renamedFile; // ใช้ไฟล์ที่เปลี่ยนชื่อ
      });

      // อัปโหลดไฟล์
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${Global.ip_8080}/gotwo/upload_p.php'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);

        if (data['file'] != null) {
          setState(() {
            _uploadedImageUrl = data['file']; // ดึง URL ไฟล์ที่อัปโหลด
            if (_uploadedImageUrl != null) {
              isImageUploaded = true; // อัปเดตสถานะเป็นรูปถูกอัปโหลด
            }
          });
        }
      } else {
        print('File upload failed');
      }
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
                  if (qr_pay != null && qr_pay!.startsWith("iVBORw0KGgo"))
                    Image.memory(
                      base64Decode(qr_pay!),
                      width: 200,
                      height: 200,
                    )
                  else
                    const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  pickAndUploadImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isImageUploaded
                      ? Colors.green[300] // เปลี่ยนสีเป็นสีเทาหลังอัปโหลดรูป
                      : Colors.blue[300],
                  minimumSize: const Size(15, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  isImageUploaded ? 'Uploaded' : 'Attach Image',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
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

  final urlup = Uri.parse('http://${Global.ip_8080}/gotwo/update_imgPay.php');
  Future<void> update_imgPay(
    String status_post_id,
    String imgPay,
  ) async {
    var request = await http.post(urlup, body: {
      "status_post_id": status_post_id,
      "imgPay": imgPay,
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
    int _currentRating = int.parse(item['review']);
    String imgShow = 'http://${Global.ip_8080}/${item['img_profile']}';
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
                                ? Colors.green[200] // Green[200] for "Verify"
                                : item['pay'] == '3'
                                    ? Colors.blue // Blue for "Pending"
                                    : item['pay'] == '4'
                                        ? Colors.orange // orange for "Refund"
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      item['pay'] == '1' || item['pay'] == 1
                          ? Icons.phone
                          : null,
                      color: const Color(0xFF1A1C43),
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Text(
                      item['pay'] == '1' || item['pay'] == 1
                          ? "${item['rider_tel'] ?? 'Unknown'}"
                          : "", // ถ้าเป็น 1 แสดง "'rider_email", ถ้าเป็น 0 ไม่แสดง
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1A1C43), // Red for "Unpaid"
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (item['pay'] == '1' || item['pay'] == '2') ||
                              isPaid
                          ? null
                          : isImageUploaded
                              ? () async {
                                  setState(() {
                                    isPaid = true;
                                  });
                                  if (item['pay'] == '1' || isPaid == true) {
                                    String status_post_id =
                                        '${item['status_post_id'] ?? 'Unknown'}';
                                    String pay = '1';
                                    String status = "2";
                                    update_pay(
                                      status_post_id,
                                      pay,
                                      status,
                                    );

                                    update_imgPay(
                                      status_post_id,
                                      _uploadedImageUrl!,
                                    );

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TabbarCus(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                }
                              : () {
                                  String price = item['price'];
                                  String promptPay = '0923198198';

                                  qrCode_view(price, promptPay);
                                  // showQrCodeDialog();
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item['pay'] == '1' || isPaid
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
                                    String status = "5";
                                    String post_id = item['post_id'];
                                    String checkstatus = '0';
                                    String cancelReason =
                                        commentController.text;
                                    String status_post_id =
                                        '${item['status_post_id'] ?? 'Unknown'}';

                                    update_cancel(status_post_id, pay,
                                        cancelReason, status);
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
