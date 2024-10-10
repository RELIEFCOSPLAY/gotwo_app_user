import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
        "http://${Global.ip_80}/gotwo/getUserId_cus.php"; // API URL
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

  final url = Uri.parse('http://${Global.ip_80}/gotwo/status_totravel.php');

  // Updated update_review function
  Future<void> update_review(String status_post_id, String pay, String review,
      String comment, String status) async {
    try {
      var request = await http.post(url, body: {
        "status_post_id": status_post_id,
        "pay": pay,
        'review': review,
        'comment': comment,
        'status': status,
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
    String status,
    String comment,
    String pay,
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
                      '${item['rider_id']} ',
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
                // Car Detail Button
                ElevatedButton(
                  onPressed: () {
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
                              child: Image.asset(
                                  "assets/images/ninja400-appcarpool.jpg"),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            double selectedRating = 1.0;
                            TextEditingController commentController =
                                TextEditingController();

                            return Center(
                              child: AlertDialog(
                                title: const Center(
                                  child: Text(
                                    'Review',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                content: SizedBox(
                                  height: 150,
                                  width: 250,
                                  child: Column(
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
                                              setState(() {
                                                selectedRating = newRating;
                                              });
                                            },),
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
                                              enabledBorder: border,
                                              focusedBorder: border,
                                              border:
                                                  const OutlineInputBorder(),
                                              hintText: 'What is your opinion?',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                          String review =
                                              selectedRating.toInt().toString();

                                          // Call the update_review function
                                          update_review(
                                            status_post_id,
                                            pay,
                                            review,
                                            comment,
                                            status,
                                          );

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TabbarCus()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
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
                              ),
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
                                    String pay = "0";
                                    if (item['pay'].toString() == "1") {
                                      pay = "2";
                                    } else if (item['pay'].toString() == "0") {
                                      pay = "0";
                                    }
                                    String cancelReason =
                                        commentController.text;
                                    String status_post_id =
                                        '${item['status_post_id'] ?? 'Unknown'}';

                                    update_cancel(
                                      status_post_id,
                                      status,
                                      cancelReason,
                                      pay,
                                    );
                                    print(status_post_id);
                                    print(cancelReason);
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
