import 'package:flutter/material.dart';

class Term extends StatefulWidget {
  const Term({Key? key}) : super(key: key);

  @override
  State<Term> createState() => _TermState();
}

class _TermState extends State<Term> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // กำหนดสีของ AppBar เป็นโปร่งใส
        elevation: 0, // ไม่มีเงาใต้ AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // ใช้ไอคอนแบ็กสีดำ
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้านี้
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Term and condotion",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      color: Color(0xFF1A1C43),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isChecked
                              ? const  Color(0xFF1A1C43)
                              : Colors.black,
                          width: 1,
                        ),
                        color: isChecked ?  Color(0xFF1A1C43) : Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: isChecked
                            ? Icon(
                                Icons.check,
                                size: 7.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 7.0,
                                color: Colors.transparent,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'I accept and agree to the Terms of Use.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF1A1C43)), // background color
                  minimumSize: MaterialStateProperty.all(
                      const Size(90, 40)), // Set minimum size here
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
