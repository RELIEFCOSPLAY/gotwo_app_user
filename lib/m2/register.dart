import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotwo_app_user/m2/bank.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List? imageBytes = await pickImage(ImageSource.gallery);
    if (imageBytes != null) {
      setState(() {
        _image = imageBytes;
      });
    } else {
      debugPrint('No image selected');
    }
  }

  // Dropdown items
  List<String> _items = ['Female', 'Male'];
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Color(0xFF1A1C43),
          ),
        ),
        backgroundColor: Colors.transparent, // กำหนดสีของ AppBar เป็นโปร่งใส
        elevation: 0, // ไม่มีเงาใต้ AppBar
          centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // ใช้ไอคอนแบ็กสีดำ
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้านี้
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_image != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(_image!),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Gender"),
                        value: selectedItem,
                        items: _items.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedItem = value;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      //  obscureText: true, // ซ่อนรหัส
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Create Password',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF1A1C43), width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: true, // ซ่อนรหัส
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BankAccount()), // ให้ NextPage() เป็นหน้าถัดไป
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF1A1C43)), // background color
                    minimumSize: MaterialStateProperty.all(
                        const Size(110, 35)), // Set minimum size here
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  try {
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
  }
  return null;
}
