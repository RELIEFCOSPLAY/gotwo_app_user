import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:gotwo_app_user/m2/login.dart';
import 'package:gotwo_app_user/m2/register.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  List<dynamic> listlBank = [];
  Future<void> fetchBank() async {
    final String url = "http://${Global.ip_8080}/gotwo/get_bank.php";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          listlBank = json.decode(response.body); // แปลง JSON เป็น List
          // ไม่เปลี่ยนค่า dropdownPickup และ dropdownDrop ที่ตั้งค่าเป็น "Select Location"
        });
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

//==========================================================================

  bool isImageSelected_idcardBtn = false;
  File? _image; // เก็บภาพที่เลือก
  String? _uploadedImageUrl; // เก็บ URL รูปภาพที่อัปโหลด

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // เปลี่ยนชื่อไฟล์เป็น "GP_timestamp"
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final directory = await getTemporaryDirectory();
      final newFileName = "GP_$timestamp${path.extension(pickedFile.path)}";
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
          });
        }
      } else {
        print('File upload failed');
      }
    }
  }

  //===============================================
  Uri url = Uri.parse('http://${Global.ip_8080}/gotwo/regis.php');
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Loginpage(),
          ),
          (Route<dynamic> route) => false,
        );
        debugPrint("Insert success: $jsonResponse");
      } else {
        debugPrint("Failed to insert: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBank();
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
          MaterialPageRoute(
              builder: (context) =>
                  Register()), // เปลี่ยน TargetPage เป็นหน้าที่ต้องการ
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
      borderSide: const BorderSide(color: Color(0xff1a1c43)),
    );

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
      ),
      value: dropdownValue, // ค่าเริ่มต้นของ Dropdown
      elevation: 16,
      style: const TextStyle(
        color: Color(0xff1a1c43),
        fontWeight: FontWeight.bold,
      ),
      borderRadius: BorderRadius.circular(18),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: [
        const DropdownMenuItem<String>(
          value: 'Bank Select',
          child: Text(
            'Bank Select',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ...listlBank.map<DropdownMenuItem<String>>((dynamic bank) {
          return DropdownMenuItem<String>(
            value: bank[
                'bank_List'], // สมมติว่า `bank_List` คือชื่อธนาคารในข้อมูลที่ดึงมา
            child: Text(bank['bank_List']),
          );
        }).toList(),
      ],
    );
  }

  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: () {
        // ตรวจสอบว่าข้อมูลครบถ้วนหรือไม่
        if (_uploadedImageUrl == null ||
            namebankAccountController.text.isEmpty ||
            accountNumberController.text.isEmpty ||
            dropdownValue == list.first) {
          // แสดงข้อความแจ้งเตือน
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please complete all fields before proceeding!",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return; // หยุดการทำงานหากข้อมูลไม่ครบ
        }

        String statusCustomer1 = "1";
        debugPrint("imgProfile: ${widget.cusCardImagePath}");
        debugPrint("Username: ${widget.username}");
        debugPrint("Email: ${widget.email}");
        debugPrint("Phone: ${widget.phone}");
        debugPrint("Gender: ${widget.gender}");
        debugPrint("password : ${widget.createPassword}");
        debugPrint("imgIdCard : $_uploadedImageUrl");
        debugPrint("bank : ${dropdownValue.toString()}");
        debugPrint("nameAccount : ${namebankAccountController.text}");
        debugPrint("numberBank : ${accountNumberController.text}");
        debugPrint("statusCustumer : $statusCustomer1");

        // ส่งข้อมูลไปยังฟังก์ชัน insert_Register
        insert_Register(
          widget.cusCardImagePath.toString(),
          widget.username,
          widget.email,
          widget.phone,
          widget.gender,
          widget.createPassword,
          _uploadedImageUrl.toString(),
          dropdownValue.toString(),
          namebankAccountController.text,
          accountNumberController.text,
          statusCustomer1,
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
            "Register",
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
              print(_uploadedImageUrl);
              pickAndUploadImage().then((_) {
                if (_uploadedImageUrl != null) {
                  setState(() {
                    isImageSelected_idcardBtn =
                        true; // เปลี่ยนสถานะเมื่อเลือกรูปภาพสำเร็จ
                    String imgShow =
                        'http://${Global.ip_8080}/$_uploadedImageUrl';
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
                              _uploadedImageUrl != null
                                  ? Image.network(
                                      imgShow) // แสดงรูปภาพที่อัปโหลด
                                  : const Text("No image selected"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                debugPrint(imgShow);
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
                  });

                  // แสดงไดอะล็อกพร้อมรูปภาพที่อัปโหลด
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
