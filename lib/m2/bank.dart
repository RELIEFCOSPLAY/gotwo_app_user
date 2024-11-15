import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:gotwo_app_user/m2/login.dart';
import 'package:gotwo_app_user/m2/register.dart';
import 'package:gotwo_app_user/m2/test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class BankAccount extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String createPassword;
  final String confirmPassword;
  final String gender;
  final String? cusCardImagePath;
  const BankAccount({
    super.key,
    required this.username,
    required this.email,
    required this.phone,
    required this.createPassword,
    required this.confirmPassword,
    required this.gender,
    this.cusCardImagePath,
  });

  @override
  State<BankAccount> createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  TextEditingController namebankAccountController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();

  static const List<String> list = <String>[
    'Bank Select',
    'Bank 1',
    'Bank 2',
  ];

  String dropdownValue = list.first;

//==========================================================================
  String? idCardImagePath;
  bool isImageSelected_idcardBtn = false;
  File? id_card_im_path;
  final picker = ImagePicker();
  Future id_getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        id_card_im_path = File(pickedFile.path);
        idCardImagePath = pickedFile.path;
      } else {
        print("No Image Picked");
      }
    });
  }

  //===============================================
  Uri url = Uri.parse('http://${Global.ip_80}/gotwo/regis.php');
  Future<void> insert_Register(
    String imgProfile,
    String name,
    String email,
    String tel,
    String gender,
    String password,
    String imgIdCard,
    String bank,
    String nameAccount,
    String numberBank,
    String statusCustomer,
  ) async {
    try {
      var response = await http.post(
        url,
        body: {
          "img_profile": imgProfile,
          "name": name,
          "email": email,
          "tel": tel,
          "gender": gender,
          "password": password,
          "img_id_card": imgIdCard,
          "bank": bank,
          "name_account": nameAccount,
          "number_bank": numberBank,
          "status_customer": statusCustomer,
        },
      );

      if (response.statusCode == 200) {
        // Check for success message from PHP
        var jsonResponse = json.decode(response.body);
        print("Insert success: $jsonResponse");
      } else {
        print("Failed to insert: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white,
          Colors.white,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: _backButton(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xff1a1c43),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _bText(),
              const SizedBox(height: 20),
              _dropdown(),
              const SizedBox(height: 10),
              _inputField("Bank account name", namebankAccountController),
              const SizedBox(height: 10),
              _inputField2("Enter account number", accountNumberController),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _idcardBtn(),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              _nextBtn(),
            ],
          ),
        ),
      ),
    );
  }

Widget _backButton() {
  return GestureDetector(
    onTap: () {
      // นำผู้ใช้ไปยังหน้าที่ต้องการ
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()), // เปลี่ยน TargetPage เป็นหน้าที่ต้องการ
      );
    },
    child: const Icon(
      Icons.arrow_back_ios,
      size: 30,
      color: Color(0xff1a1c43),
    ),
  );
}


  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xff1a1c43)),
    );

    
  return SizedBox(
    child: TextField(
      style: const TextStyle(
        color: Color(0xff1a1c43),
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xff1a1c43)),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    ),
  );
  }

Widget _inputField2(String hintText, TextEditingController controller,
    {isPassword = false}) {
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Color(0xff1a1c43)),
  );

  return SizedBox(
    child: TextField(
      style: const TextStyle(
        color: Color(0xff1a1c43),
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xff1a1c43)),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
      keyboardType: TextInputType.number, // กำหนดประเภทคีย์บอร์ดเป็นตัวเลข
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly, // ยอมรับเฉพาะตัวเลข
      ],
    ),
  );
}
  Widget _bText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start, // จัดให้อยู่ชิดซ้าย
      children: [
        Text(
          "Bank Account",
          style: TextStyle(
            fontSize: 26,
            color: Color(0xff1a1c43),
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          // เส้นใต้ข้อความ
          color: Color(0xff1a1c43), // สีของเส้น
          thickness: 1, // ความหนาของเส้น
        ),
      ],
    );
  }

  Widget _dropdown() {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xff1a1c43)));

    return DropdownButtonFormField<String>(
      hint: const Text('Gender'),
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
      ),
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(
        color: Color(0xff1a1c43),
        fontWeight: FontWeight.bold,
      ),
      borderRadius: BorderRadius.circular(18),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: _snackBarnotification(),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        String statusCustomer0 = "0";
        debugPrint("imgProfile: ${widget.cusCardImagePath}");
        debugPrint("Username: ${widget.username}");
        debugPrint("Email: ${widget.email}");
        debugPrint("Phone: ${widget.phone}");
        debugPrint("Gender: ${widget.gender}");
        debugPrint("password : ${widget.createPassword}");
        debugPrint("imgIdCard : $idCardImagePath");
        debugPrint("bank : ${dropdownValue.toString()}");
        debugPrint("nameAccount : ${namebankAccountController.text}");
        debugPrint("numberBank : ${accountNumberController.text}");
        debugPrint("statusCustumer : $statusCustomer0");

        insert_Register(
          widget.cusCardImagePath.toString(),
          widget.username,
          widget.email,
          widget.phone,
          widget.gender,
          widget.createPassword,
          idCardImagePath.toString(),
          dropdownValue.toString(),
          namebankAccountController.text,
          accountNumberController.text,
          statusCustomer0,
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Loginpage(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 24),
        foregroundColor: Colors.blue,
        backgroundColor: const Color(0xff1a1c43),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 2),
      ),
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          )),
    );
  }

  Widget _idcardBtn() {
    return SizedBox(
      width: 100,
      height: 50,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print(id_card_im_path);
              id_getImageGallery().then((_) {
                if (id_card_im_path != null) {
                  setState(() {
                    isImageSelected_idcardBtn =
                        true; // เปลี่ยนสถานะเมื่อเลือกรูปภาพสำเร็จ
                  });

                  // แสดงไดอะล็อกพร้อมรูปภาพที่อัปโหลด
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Id card",
                          style: TextStyle(
                            color: Color(0xff1a1c43),
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            id_card_im_path != null
                                ? Image.file(
                                    id_card_im_path!) // แสดงรูปภาพที่อัปโหลด
                                : const Text("No image selected"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              print(id_card_im_path);
                            },
                            child: const Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Colors.white,
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                    color: isImageSelected_idcardBtn
                        ? Colors.green.shade200
                        : const Color(0xff1a1c43),
                  ),
                ),
              ),
            ),
            child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      Icons.co_present,
                      color: isImageSelected_idcardBtn
                          ? Colors.green.shade200
                          : const Color(0xff1a1c43),
                      size: 20.0,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Id Card",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isImageSelected_idcardBtn
                            ? Colors.green.shade200
                            : const Color(0xff1a1c43),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _snackBarnotification() {
    if (namebankAccountController.text == "" &&
        accountNumberController.text == "") {
      return Container(
        padding: const EdgeInsets.all(8),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent)),
        child: const Row(
          children: [
            SizedBox(
              width: 48,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Oh snap!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff1a1c43),
                    ),
                  ),
                  Text(
                    "Username or Password is Wrong",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff1a1c43),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
