// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gotwo_app_user/m2/bank.dart';
// import 'package:image_picker/image_picker.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emaiController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController createPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   static const List<String> list = <String>[
//     'Male',
//     'Female',
//   ];
//   String dropdownValue = list.first;

//   String? cusCardImagePath;
//   File? cus_card_im_path;
//   final picker = ImagePicker();
//   Future cus_getImageGallery() async {
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );

//     setState(() {
//       if (pickedFile != null) {
//         cus_card_im_path = File(pickedFile.path);
//         cusCardImagePath = pickedFile.path;
//       } else {
//         print("No Image Picked");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//         begin: Alignment.topRight,
//         end: Alignment.bottomLeft,
//         colors: [
//           Colors.white,
//           Colors.white,
//         ],
//       )),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: const Color(0xffffffff),
//           title: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: _backButton(),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.only(left: 70),
//                       child: Text(
//                         "Register",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 28,
//                             color: Color(0xff1a1c43),
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),automaticallyImplyLeading: false,
//         ),
//         body: _page(),
//       ),
//     );
//   }

//   Widget _page() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _addPhoto(),
//               const SizedBox(height: 20),
//               _inputField("Username", usernameController),
//               const SizedBox(height: 10),
//               _inputField("Email", emaiController),
//               const SizedBox(height: 10),
//               _inputField("Phone number", phoneController),
//               const SizedBox(height: 10),
//               _dropdown(),
//               const SizedBox(height: 10),
//               _inputField("Create Password", createPasswordController,
//                   isPassword: true),
//               const SizedBox(height: 10),
//               _inputField("Confirm Password", confirmPasswordController,
//                   isPassword: true),
//               const SizedBox(height: 15),
//               _registerBtn(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _backButton() {
//     return GestureDetector(
//       onTap: () {
//         debugPrint("back");
//       },
//       child: const Icon(
//         Icons.arrow_back_ios,
//         size: 30,
//         color: Color(0xff1a1c43),
//       ),
//     );
//   }

//   Widget _addPhoto() {
//     return Column(
//       children: [
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xffffffff),
//             elevation: 0.0,
//             shadowColor: Colors.transparent,
//           ),
//           onPressed: () {
//             cus_getImageGallery(); // เรียกใช้งานฟังก์ชันเพื่อเลือกรูปภาพ
//           },
//           child: Container(
//             width: 70, // ตั้งขนาดของ Container
//             height: 70, // ตั้งขนาดของ Container
//             decoration: BoxDecoration(
//               color: const Color(0xff1a1c43),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: const Color(0xff1a1c43),
//                 width: 3,
//               ),
//             ),
//             child: cus_card_im_path !=
//                     null // ตรวจสอบว่ามีรูปภาพที่เลือกหรือไม่
//                 ? ClipOval(
//                     // ใช้ ClipOval เพื่อทำให้รูปเป็นวงกลม
//                     child: Image.file(
//                       File(cusCardImagePath!),
//                       fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับ Container
//                       width: 70,
//                       height: 70,
//                     ),
//                   )
//                 : const Icon(
//                     Icons.person,
//                     color: Colors.white,
//                     size: 25,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _inputField(String hintText, TextEditingController controller,
//       {isPassword = false}) {
//     var border = OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: const BorderSide(color: Color(0xff1a1c43)));

//     return  ConstrainedBox(
//     constraints: const BoxConstraints(
//       maxHeight: 50, 
//     ),
//     child:TextField(
//       style: const TextStyle(color: Color(0xff1a1c43)),
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(color: Color(0xff1a1c43)),
//         enabledBorder: border,
//         focusedBorder: border,
//       ),
//       obscureText: isPassword,)
//     );
//   }

//   Widget _dropdown() {
//     var border = OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: const BorderSide(color: Color(0xff1a1c43)));

//     return 
//      ConstrainedBox(
//     constraints: const BoxConstraints(
//       maxHeight: 50, 
//     ),child:DropdownButtonFormField<String>(
//       hint: const Text('Gender'),
//       decoration: InputDecoration(
//         enabledBorder: border,
//         focusedBorder: border,
//       ),
//       value: dropdownValue,
//       elevation: 16,
//       style: const TextStyle(
//           color: Color(0xff1a1c43), fontWeight: FontWeight.bold),
//       borderRadius: BorderRadius.circular(30),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       items: list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//   ) );
//   }

//   Widget _registerBtn() {
//     return ElevatedButton(
//       onPressed: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: _snackBarnotification(),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//         );
//         debugPrint("Username : ${usernameController.text}");
//         debugPrint("Emai : ${emaiController.text}");
//         debugPrint("Phone : ${phoneController.text}");
//         debugPrint("Create Password : ${createPasswordController.text}");
//         debugPrint("Confirm Password : ${confirmPasswordController.text}");
//         debugPrint("Gender: ${dropdownValue.toLowerCase()}");
//         debugPrint(cusCardImagePath);

//        // Navigate to GotwoInformation and send data
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BankAccount(
//               username: usernameController.text,
//               email: emaiController.text,
//               phone: phoneController.text,
//               createPassword: createPasswordController.text,
//               confirmPassword: confirmPasswordController.text,
//               gender: dropdownValue.toLowerCase(),
//               cusCardImagePath: cusCardImagePath,
//             ),
//           ),
//           (Route<dynamic> route) => false,
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         fixedSize: const Size(120, 34),
//         foregroundColor: Colors.blue,
//         backgroundColor: const Color(0xff1a1c43),
//         shape: const StadiumBorder(),
//         padding: const EdgeInsets.symmetric(vertical: 6),
//       ),
//       child: const SizedBox(
//           width: double.infinity,
//           child: Text(
//             "Next",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 20, color: Colors.white),
//           )),
//     );
//   }

//   Widget _snackBarnotification() {
//     if (usernameController.text == "" &&
//         emaiController.text == "" &&
//         phoneController.text == "" &&
//         createPasswordController.text == "" &&
//         confirmPasswordController.text == "" &&
//         dropdownValue == "Gender") {
//       return Container(
//         padding: const EdgeInsets.all(8),
//         height: 70,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.redAccent)),
//         child: const Row(
//           children: [
//             SizedBox(
//               width: 48,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Oh snap!",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Color(0xff1a1c43),
//                     ),
//                   ),
//                   Text(
//                     "Username or Password is Wrong",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xff1a1c43),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     return Container();
//   }
// }
