// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
// import 'package:intl/intl.dart';

// class CusTotravel extends StatefulWidget {
//   final Map<String, dynamic> data; // รับข้อมูลจากหน้าก่อนหน้า

//   const CusTotravel({Key? key, required this.data}) : super(key: key);

//   @override
//   State<CusTotravel> createState() => _CusTotravelState();
// }

// class _CusTotravelState extends State<CusTotravel> {
//   late Map<String, dynamic> item; // ใช้เก็บข้อมูลที่รับมาจากหน้าก่อนหน้า
//   var border = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(18),
//       borderSide: const BorderSide(color: Color(0xff1a1c43)));

//   @override
//   void initState() {
//     super.initState();
//     // ตั้งค่า item จากข้อมูลที่ได้รับจาก widget.data
//     item = widget.data;
//   }

//   String formatDate(String date) {
//     try {
//       DateTime parsedDate = DateTime.parse(date);

//       return DateFormat('dd/MM/yyyy').format(parsedDate);
//     } catch (e) {
//       return "";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'To travel',
//           style: TextStyle(
//             color: Color(0xFF1A1C43),
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 5),
//                 Image.asset(
//                   item['image'] ?? 'assets/images/profile.png',
//                   width: 50,
//                   height: 50,
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${item['rider_id']} ',
//                       style: const TextStyle(
//                         color: Color(0xFF1A1C43),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     Icon(
//                       (item['gender']?.toLowerCase() == 'male')
//                           ? Icons.male
//                           : Icons.female,
//                       color: const Color(0xFF1A1C43),
//                       size: 15,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.phone, color: Color(0xFF1A1C43), size: 15),
//                     const SizedBox(width: 5),
//                     Text(
//                       '${item['rider_tel']} ',
//                       style: const TextStyle(
//                         color: Color(0xFF1A1C43),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Rate ',
//                       style: TextStyle(
//                         color: Color(0xFF1A1C43),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 11,
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     Icon(Icons.star, color: Colors.yellow, size: 15),
//                     Icon(Icons.star, color: Colors.yellow, size: 15),
//                     Icon(Icons.star, color: Colors.yellow, size: 15),
//                     Icon(Icons.star, color: Colors.yellow, size: 15),
//                     Icon(Icons.star, color: Colors.yellow, size: 15),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.calendar_today,
//                         color: Color(0xFF1A1C43), size: 15),
//                     const SizedBox(width: 5),
//                     Text(
//                       "Date: ${formatDate(widget.data['date'])}",
//                       textAlign: TextAlign.start,
//                       style: const TextStyle(
//                           fontSize: 12, color: Color(0xff1a1c43),fontWeight: FontWeight.bold, ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${item['price']} THB',
//                       style: const TextStyle(
//                         color: Color(0xFF1A1C43),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 /////////////////////////////////
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Center(
//                           child: AlertDialog(
//                             title: const Center(
//                               child: Text(
//                                 'Motorcycle detail',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             content: SizedBox(
//                               width: 200.0,
//                               height: 250.0,
//                               child: Image.asset(
//                                   "assets/images/ninja400-appcarpool.jpg"),
//                             ),
//                             actions: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('Close'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1A1C43),
//                     minimumSize: const Size(5, 5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'car detail',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 ////////////////////////////
//                 Container(
//                   width: 300,
//                   height: 180,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey, width: 1),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 15, right: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Text(
//                             'Pickup',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             const Icon(Icons.my_location,
//                                 color: Colors.green, size: 18),
//                             const SizedBox(width: 10),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue[100],
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Text(
//                                 '${item['pick_up']}',
//                                 style: const TextStyle(
//                                   color: Color(0xFF1A1C43),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 11,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 3),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40.0),
//                           child: Text(
//                             '${item['comment_pick']}',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 30.0),
//                           child: Divider(
//                               color: Color(0xFF1A1C43),
//                               thickness: 0.5,
//                               height: 1),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Text(
//                             'Drop',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.pin_drop,
//                                 color: Color(0xFFD3261A), size: 18),
//                             const SizedBox(width: 10),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue[100],
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Text(
//                                 '${item['at_drop']}',
//                                 style: const TextStyle(
//                                   color: Color(0xFF1A1C43),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 3),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40.0),
//                           child: Text(
//                             '${item['comment_drop']}',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 30.0),
//                           child: Divider(
//                               color: Color(0xFF1A1C43),
//                               thickness: 0.5,
//                               height: 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 17),
//                 Text(
//                   item['status_helmet'] == '0'
//                       ? 'Bring your own a helmet.'
//                       : 'There is a helmet for you.',
//                   style: TextStyle(
//                     color: item['status_helmet'] == '0'
//                         ? Colors.red
//                         : Colors.green,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                   ),
//                 ),
//                 const SizedBox(height: 17),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return Center(
//                               child: AlertDialog(
//                                 title: const Center(
//                                   child: Text(
//                                     'Review',
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 content: Container(
//                                   height: 100,
//                                   width: 250,
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 5),
//                                         child: RatingBar.builder(
//                                           initialRating: 1,
//                                           minRating: 1,
//                                           direction: Axis.horizontal,
//                                           allowHalfRating: false,
//                                           itemSize: 25,
//                                           itemCount: 5,
//                                           itemPadding: EdgeInsets.symmetric(
//                                               horizontal: 1),
//                                           itemBuilder: (context, _) => Icon(
//                                             Icons.star,
//                                             color: Colors.amber,
//                                           ),
//                                           onRatingUpdate: (rating) {
//                                             print(rating);
//                                           },
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             top: 10, bottom: 10),
//                                         child: Container(
//                                           width: 270,
//                                           height: 50,
//                                           child: TextField(
//                                             decoration: InputDecoration(
//                                               enabledBorder: border,
//                                               focusedBorder: border,
//                                               border: OutlineInputBorder(),
//                                               hintText: 'What is your opinion?',
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 actions: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       ElevatedButton(
//                                         onPressed: () {},
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.blue,
//                                           minimumSize: const Size(15, 29),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                           ),
//                                         ),
//                                         child: const Text(
//                                           'Send',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.normal,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ),
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: Text('Close',
//                                             style:
//                                                 TextStyle(color: Colors.red)),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         minimumSize: const Size(90, 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       child: const Text(
//                         'Success',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         minimumSize: const Size(90, 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
