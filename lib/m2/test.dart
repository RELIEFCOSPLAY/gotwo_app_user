// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;

// class Joindetail extends StatefulWidget {
//   final Map<String, dynamic> item; // รับข้อมูลจากหน้าแรก

//   const Joindetail({Key? key, required this.item}) : super(key: key);

//   @override
//   State<Joindetail> createState() => _JoindetailState();
// }

// class _JoindetailState extends State<Joindetail> {
//   bool isLoading = true;
//   Map<String, dynamic>? item;
//   final storage = const FlutterSecureStorage();
//   String? emails;
//   String? userId; // เก็บ ID ของผู้ใช้หลังจากดึงมา

//   Future<void> loadLoginInfo() async {
//     String? savedEmail = await storage.read(key: 'email');
//     setState(() {
//       emails = savedEmail;
//     });
//     if (emails != null) {
//       fetchUserId(emails!); // เรียกใช้ API เพื่อตรวจสอบ user id
//     }
//   }

//   Future<void> fetchUserId(String email) async {
//     final String url = "http://192.168.110.237:80/gotwo/getUserId.php"; // URL API
//     try {
//       final response = await http.post(Uri.parse(url), body: {
//         'email': email, // ส่ง email เพื่อค้นหา user id
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success']) {
//           setState(() {
//             userId = data['user_id']; // เก็บ user id ที่ได้มา
//           });
//         } else {
//           print('Error: ${data['message']}');
//         }
//       } else {
//         print("Failed to fetch user id");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     item = widget.item; // ใช้ข้อมูล item ที่ส่งมาจากหน้าแรก
//     loadLoginInfo();
//   }

//   final url = Uri.parse('http://192.168.110.237:80/gotwo/post_cus2.php');

//   Future<void> updateOrInsert(
//     String status,
//     String reason,
//     String post_id,
//     String customer_id,
//     String pay,
//     String review,
//     String comment,
//   ) async {
//     final response = await http.post(url, body: {
//       "action": "UPDATE", // เพิ่ม action สำหรับการอัปเดต
//       "status": status,
//       "reason": reason,
//       "post_id": post_id,
//       "customer_id": customer_id,
//       "pay": pay,
//       "review": review,
//       "comment": comment,
//     });

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['error'] != null) {
//         showError(data['error']); // แสดงข้อผิดพลาดที่ได้จาก API
//       } else {
//         showSuccess(data['message']); // แสดงข้อความสำเร็จ
//       }
//     } else {
//       showError('Error: ${response.statusCode}, Body: ${response.body}');
//     }
//   }

//   void showError(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void showSuccess(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Join',
//           style: TextStyle(
//             color: Color(0xFF1A1C43),
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 5),
//                   Image.network(
//                     item!['image'] ?? 'https://your-default-image-url.com/default.png',
//                     width: 50,
//                     height: 50,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Image.asset('assets/images/profile.png', width: 50, height: 50);
//                     },
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     '${item!['rider_id']}',
//                     style: const TextStyle(
//                       color: Color(0xFF1A1C43),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (userId != null && item!['post_id'] != null) {
//                         String status = 'required';
//                         String reason = 'wait too long';
//                         String post_id = item!['post_id'].toString();
//                         String customer_id = userId!;
//                         String pay = '0';
//                         String review = '0';
//                         String comment = 'cancel';

//                         updateOrInsert(status, reason, post_id, customer_id, pay, review, comment);
//                       } else {
//                         showError("User ID or Post ID is missing.");
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       minimumSize: const Size(90, 40),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     child: const Text(
//                       'Join',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
