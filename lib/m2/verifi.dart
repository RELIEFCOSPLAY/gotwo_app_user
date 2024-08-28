import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotwo_app_user/m2/join.dart';

class Verifi extends StatefulWidget {
  const Verifi({Key? key}) : super(key: key);

  @override
  State<Verifi> createState() => _VerifiState();
}

class _VerifiState extends State<Verifi> {
  final Map<String, String> item = {
    'number': '098-xxx-xxxx',
  };

///////////////// กล่อง ////////////////////////////
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

////////////////// Time ///////////////////////////
  Timer? _timer;
  int _start = 60;
  bool _isTimerActive = true;
/////////// Reset OTP ////////////////////////
  void _resendOTP() {
    _start = 60; // Reset the timer
    _isTimerActive = true; // Activate the timer
    _startTimer(); // Start the timer countdown again
    _clearTextFields(); // Clear the text fields
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isTimerActive = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _handleInputChange(int index) {
    if (_controllers[index].text.isNotEmpty &&
        index < _controllers.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _clearTextFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus(); // // ลบตัวเลขแล้วเริ่มใหม่
  }

  void _showSuccessPopup(BuildContext context) {
    String enteredCode =
        _controllers.map((controller) => controller.text).join();
    String expectedCode = '1234'; // รหัส

    if (enteredCode == expectedCode) {
      showDialog(
        context: context,
        barrierDismissible: false, // ทำให้ไม่สามารถกดที่อื่นนอกจาก popup ได้
        builder: (BuildContext context) {
          return const AlertDialog(
            //////////////-Check-/////////////////////////////
            content: Column(
            
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: Colors.green, size: 100),
                SizedBox(height: 30),
                Text(
                  'Register success',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            actions: [],
          );
        },
      );
      // เวลาที่จะโชว์ popup
      Future.delayed(const Duration(seconds: 2), () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Join()),
        // );
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible:
            false, //  // ทำให้ไม่สามารถกดที่อื่นนอกจาก popup ได้
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, color: Colors.red, size: 100),
                SizedBox(height: 20),
                Text(
                  'Verification Failed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            // content: Text('Incorrect OTP. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // อยู่หน้าเดิม
                  _clearTextFields(); // ลบเลขทิ้ง
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> firstItem = item;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verification',
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
            // Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Verification code sent to",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1A1C43),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${firstItem['number']}',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C43), // สีปุ่ม
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) => _handleInputChange(index),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    _isTimerActive
                        ? Text(
                            'Resend OTP in $_start seconds',
                            style: const TextStyle(
                              color: Color(0xFF1A1C43),
                              fontSize: 10,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _resendOTP();
                              });
                            },
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: Color(0xFF1A1C43),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSuccessPopup(context); // โชว์ popup เมื่อกดปุ่ม
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF1A1C43)),
                minimumSize: MaterialStateProperty.all(const Size(90, 40)),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
