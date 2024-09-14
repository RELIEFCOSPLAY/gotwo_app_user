// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:http/http.dart' as http;
// import 'joindetail.dart';

// class Join extends StatefulWidget {
//   const Join({Key? key}) : super(key: key);

//   @override
//   State<Join> createState() => _JoinState();
// }

// class _JoinState extends State<Join> {
//   List<dynamic> listData = [];
//   List<dynamic> filteredList = [];

//   String? selectedPickup;
//   String? selectedDrop;
//   String? selectedOption;

//   final List<String> pickupLocations = [
//     'F1',
//     'Central',
//     'Airport',
//     'Station',
//     'Mall',
//     'Park',
//     'University',
//     'Downtown',
//     'Hotel',
//     'Restaurant'
//   ];

//   final List<String> dropLocations = [
//     'F1',
//     'Central',
//     'Airport',
//     'Station',
//     'Mall',
//     'Park',
//     'University',
//     'Downtown',
//     'Hotel',
//     'Restaurant'
//   ];

//   final List<String> selectOptions = ['male', 'female'];

//   Future<void> fetchData() async {
//     final String url = "http://192.168.110.237:8080/gotwo/post.php";
//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         setState(() {
//           listData = json.decode(response.body);
//           filteredList = listData;
//         });
//       } else {
//         print("Failed to load data");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void filterData() {
//     setState(() {
//       filteredList = listData.where((item) {
//         final matchesPickup =
//             selectedPickup == null || item['pick_up'] == selectedPickup;
//         final matchesDrop =
//             selectedDrop == null || item['at_drop'] == selectedDrop;
//         final matchesGender =
//             selectedOption == null || item['rider_gender'] == selectedOption;

//         return matchesPickup && matchesDrop && matchesGender;
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildScreen(),
//       backgroundColor: Colors.white,
//       bottomNavigationBar: Bar(), // ใช้ Bar() ใน bottomNavigationBar
//     );
//   }

//   Widget _buildScreen() {
//     return Column(
//       children: [
//         const SizedBox(height: 30),
//         const Center(
//           child: Text(
//             'Join',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 30,
//               color: Color(0xFF1A1C43),
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         _dropdown_p(), // เรียกใช้ dropdown
//         const SizedBox(height: 8),
//         Expanded(
//           child: filteredList.isEmpty
//               ? const Center(
//                   child: Text('No data found'),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 20, horizontal: 10),
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     final item = filteredList[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   Joindetail(item: item),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: const Color(0xFF1A1C43),
//                           elevation: 2,
//                           minimumSize: const Size(350, 100),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             side: const BorderSide(
//                               color: Color(0xFF1A1C43),
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/profile.png',
//                                   height: 40,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'From: ${item['pick_up']} ',
//                                           style: const TextStyle(
//                                             color: Color(0xFF1A1C43),
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                         const Icon(Icons.arrow_forward),
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           'To: ${item['at_drop']}',
//                                           style: const TextStyle(
//                                             color: Color(0xFF1A1C43),
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Text(
//                                       'Date: ${item['date']}',
//                                       style: const TextStyle(fontSize: 11.5),
//                                     ),
//                                     Text(
//                                       'Time: ${item['time']}',
//                                       style: const TextStyle(fontSize: 11.5),
//                                     ),
//                                     Text(
//                                       'Gender: ${item['rider_gender']}',
//                                       style: const TextStyle(fontSize: 11.5),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 30),
//                               child: Text(
//                                 '${item['price']} THB',
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _dropdown_p() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     child: DropdownSearch<String>(
//                       popupProps: PopupProps.dialog(
//                         showSearchBox: true,
//                       ),
//                       items: pickupLocations,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedPickup = value;
//                         });
//                       },
//                       selectedItem: selectedPickup,
//                       dropdownDecoratorProps: DropDownDecoratorProps(
//                         dropdownSearchDecoration: InputDecoration(
//                           labelText: "Pickup",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     child: DropdownSearch<String>(
//                       popupProps: PopupProps.dialog(
//                         showSearchBox: true,
//                       ),
//                       items: dropLocations,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedDrop = value;
//                         });
//                       },
//                       selectedItem: selectedDrop,
//                       dropdownDecoratorProps: DropDownDecoratorProps(
//                         dropdownSearchDecoration: InputDecoration(
//                           labelText: "Drop",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             margin: const EdgeInsets.only(left: 120, right: 120),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1C43),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     if (selectedPickup != null && selectedDrop != null) {
//                       filterData();
//                     } else {
//                       print('Please select Pickup and Drop,');
//                     }
//                   },
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'Search',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedPickup = null;
//                       selectedDrop = null;
//                       selectedOption = null;
//                       filteredList = listData;
//                     });
//                   },
//                   icon: const Icon(Icons.refresh),
//                   color: Colors.red,
//                   tooltip: 'Reset',
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   width: 110,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: const Color(0xFF1A1C43),
//                       width: 1,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: DropdownButton<String>(
//                       isExpanded: true,
//                       value: selectedOption,
//                       hint: const Text('Gender'),
//                       items: selectOptions.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedOption = newValue;
//                           filterData();
//                         });
//                       },
//                       underline: Container(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget Bar() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: const Color(0xff1a1c43),
//             backgroundColor: Colors.white,
//             shadowColor: Colors.transparent,
//           ),
//           onPressed: () {
//             debugPrint("Dashboard");
//           },
//           child: const Column(
//             children: [
//               Icon(
//                 Icons.home,
//                 size: 30.0,
//               ),
//               Text("Dashboard")
//             ],
//           ),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: const Color(0xff1a1c43),
//             backgroundColor: Colors.white,
//             shadowColor: Colors.transparent,
//           ),
//           onPressed: () {
//             debugPrint("Status");
//           },
//           child: const Column(
//             children: [
//               Icon(
//                 Icons.grading,
//                 size: 30.0,
//               ),
//               Text("Status")
//             ],
//           ),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: const Color(0xff1a1c43),
//             backgroundColor: Colors.white,
//             shadowColor: Colors.transparent,
//           ),
//           onPressed: () {
//             debugPrint("Profile");
//           },
//           child: const Column(
//             children: [
//               Icon(
//                 Icons.account_circle,
//                 size: 30.0,
//               ),
//               Text("Profile")
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
