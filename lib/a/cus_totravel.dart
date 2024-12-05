import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CusTotravel extends StatefulWidget {
  final Map<String, dynamic> data; // Data from the previous screen

  const CusTotravel({Key? key, required this.data}) : super(key: key);

  @override
  State<CusTotravel> createState() => _CusTotravelState();
}

class _CusTotravelState extends State<CusTotravel> {
  late Map<String, dynamic> item;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Color(0xff1a1c43)),
  );
  String? emails;
  String? userId;
  final storage = const FlutterSecureStorage();

  bool isImageSelected = false;

  String? _imageUrl; // เก็บ URL รูปภาพที่อัปโหลด
  Future<void> loadLoginInfo() async {
    String? savedEmail = await storage.read(key: 'email');
    setState(() {
      emails = savedEmail;
    });
    if (emails != null) {
      fetchUserId(emails!);
    }
  }

  Future<void> fetchUserId(String email) async {
    final String url =
        "http://${Global.ip_8080}/gotwo/getUserId_cus.php"; // API URL
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
        print("Failed to fetch user ID");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final url = Uri.parse('http://${Global.ip_8080}/gotwo/status_totravel.php');

  // Updated update_review function
  Future<void> update_review(
    String status_post_id,
    String pay,
    String review,
    String comment,
    String status,
    String imgSuccess,
  ) async {
    try {
      var request = await http.post(url, body: {
        "status_post_id": status_post_id,
        "pay": pay,
        'review': review,
        'comment': comment,
        'status': status,
        'imgSuccess': imgSuccess,
      });

      if (request.statusCode == 200) {
        // Data sent successfully
        print('Success: ${request.body}');
      } else {
        // There was a problem sending data
        print('Error: ${request.statusCode}, Body: ${request.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> update_cancel(
    String status_post_id,
    String pay,
    String review,
    String comment,
    String status,
    String imgSuccess,
  ) async {
    var request = await http.post(url, body: {
      "status_post_id": status_post_id,
      "pay": pay,
      'review': review,
      'comment': comment,
      'status': status,
      'imgSuccess': imgSuccess,
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
          'To travel',
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
                    const Icon(Icons.phone, color: Color(0xFF1A1C43), size: 15),
                    const SizedBox(width: 5),
                    Text(
                      '${item['rider_tel']} ',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
                // Car Detail Button
                ElevatedButton(
                  onPressed: () {
                    String imgShowCar =
                        'http://${Global.ip_8080}/${item['img_car_picture']}';
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            title: const Center(
                              child: Text(
                                'Motorcycle detail',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            content: SizedBox(
                              width: 200.0,
                              height: 250.0,
                              child: Image.network(imgShowCar),
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
                                    child: const Text('Close'),
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
                    'car detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Pickup and Drop Details
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
                const SizedBox(height: 17),
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
                const SizedBox(height: 17),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Button
                    ElevatedButton(
                      onPressed: () {
                        File? _image;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String reviewR = "1";
                            TextEditingController commentController =
                                TextEditingController();

                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: const Center(
                                    child: Text(
                                      'Review',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  content: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: RatingBar.builder(
                                          initialRating: 1,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemSize: 25,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (newRating) {
                                            reviewR =
                                                newRating.toInt().toString();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: SizedBox(
                                          width: 270,
                                          height: 50,
                                          child: TextField(
                                            controller: commentController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              hintText: 'Your opinion?',
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final picker = ImagePicker();
                                          final pickedFile =
                                              await picker.pickImage(
                                            source: ImageSource.gallery,
                                          );

                                          if (pickedFile != null) {
                                            final timestamp = DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString();
                                            final directory =
                                                await getTemporaryDirectory();
                                            final newFileName =
                                                "GUSUCC_$timestamp${path.extension(pickedFile.path)}";
                                            final newFilePath = path.join(
                                                directory.path, newFileName);

                                            final renamedFile =
                                                await File(pickedFile.path)
                                                    .copy(newFilePath);

                                            setState(() {
                                              _image =
                                                  renamedFile; // ใช้ไฟล์ที่เปลี่ยนชื่อ
                                            });
                                            var request = http.MultipartRequest(
                                              'POST',
                                              Uri.parse(
                                                  'http://${Global.ip_8080}/gotwo/upload_p.php'),
                                            );
                                            request.files.add(
                                                await http.MultipartFile
                                                    .fromPath(
                                                        'image', _image!.path));

                                            var response = await request.send();
                                            if (response.statusCode == 200) {
                                              final res = await http.Response
                                                  .fromStream(response);
                                              final data =
                                                  json.decode(res.body);

                                              if (data['file'] != null) {
                                                setState(() {
                                                  _imageUrl = data[
                                                      'file']; // ดึง URL ไฟล์ที่อัปโหลด
                                                });
                                              }
                                            } else {
                                              debugPrint('File upload failed');
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: const Text("Select Image",
                                            style: TextStyle(
                                                color: Color(0xFF1A1C43))),
                                      ),
                                      const SizedBox(height: 20),
                                      _image != null
                                          ? Image.file(
                                              _image!,
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ) // แสดงรูปภาพหากเลือกแล้ว
                                          : const Text("No image selected"),
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            String status_post_id =
                                                '${item['status_post_id'] ?? 'Unknown'}';
                                            String comment =
                                                commentController.text;
                                            String pay = '3';
                                            String status = '4';
                                            String review = reviewR;

                                            // Call the update_review function

                                            update_review(
                                                status_post_id,
                                                pay,
                                                review,
                                                comment,
                                                status,
                                                _imageUrl!);

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TabbarCus()),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            minimumSize: const Size(15, 29),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: const Text(
                                            'Confirm',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close dialog
                                          },
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
                        'Success',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    ///////////////////////////////////
                    // Cancel Button
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
                                    String status = '5';
                                    String review = '0';
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
                                    String comment = commentController.text;
                                    String status_post_id =
                                        '${item['status_post_id'] ?? 'Unknown'}';
                                    String post_id = item['post_id'];
                                    String checkstatus = '0';
                                    String imageUrlNo = 'No imageUrl';

                                    update_cancel(status_post_id, pay, review,
                                        comment, status, imageUrlNo);
                                    check_status(
                                      checkstatus,
                                      post_id,
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TabbarCus()),
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
