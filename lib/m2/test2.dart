import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import dropdown_search
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:http/http.dart' as http;
import 'joindetail.dart'; // Import หน้าจอแสดงรายละเอียด

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  int index = 0;
  List<dynamic> listData = [];
  List<dynamic> filteredList = []; // เก็บข้อมูลที่กรองแล้ว

  // ตัวแปรสำหรับ DropdownButton
  String? selectedPickup; // เก็บค่าที่เลือกจาก Pickup
  String? selectedDrop; // เก็บค่าที่เลือกจาก Drop
  String? selectedOption; // ตัวเลือกเพศ

  // ข้อมูลตัวเลือกสำหรับ Dropdown
  final List<String> pickupLocations = [
    'F1',
    'Central',
    'Airport',
    'Station',
    'Mall',
    'Park',
    'University',
    'Downtown',
    'Hotel',
    'Restaurant'
  ];

  final List<String> dropLocations = [
    'F1',
    'Central',
    'Airport',
    'Station',
    'Mall',
    'Park',
    'University',
    'Downtown',
    'Hotel',
    'Restaurant'
  ];

  final List<String> selectOptions = ['male', 'female'];

  // ฟังก์ชันดึงข้อมูลจากเซิร์ฟเวอร์
  Future<void> fetchData() async {
    final String url = "http://192.168.110.237:8080/gotwo/post.php";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          listData = json.decode(response.body); // แปลง JSON เป็น List
          filteredList =
              listData; // เริ่มต้นให้ filteredList มีค่าเท่ากับ listData ทั้งหมด
        });
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // ดึงข้อมูลเมื่อเริ่มแอป
  }

  // ฟังก์ชันสำหรับกรองข้อมูลใน listData
  void filterData() {
    setState(() {
      filteredList = listData.where((item) {
        // กรองตามค่าที่ผู้ใช้เลือก (Pickup, Drop และ Gender)
        final matchesPickup =
            selectedPickup == null || item['pick_up'] == selectedPickup;
        final matchesDrop =
            selectedDrop == null || item['at_drop'] == selectedDrop;
        final matchesGender =
            selectedOption == null || item['rider_gender'] == selectedOption;

        return matchesPickup && matchesDrop && matchesGender;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      backgroundColor: Colors.white, // แสดงหน้าจอตาม index

      // แสดง Navigation Bar ด้านล่าง
    );
  }

  // ฟังก์ชันสร้างหน้าจอหลัก
  Widget _buildScreen() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Center(
          child: Text(
            'Join',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color(0xFF1A1C43),
            ),
          ),
        ),
        const SizedBox(height: 5),
        _dropdown_p(), // Dropdown สำหรับการเลือก Pickup และ Drop
        const SizedBox(height: 8),
        Expanded(
          child: filteredList.isEmpty
              ? const Center(
                  child: Text('No data found'), // หากไม่พบข้อมูลหลังการค้นหา
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Joindetail(item: item),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1A1C43),
                          elevation: 2,
                          minimumSize: const Size(350, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color(0xFF1A1C43),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/profile.png',
                                  height: 40,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'From: ${item['pick_up']} ',
                                          style: const TextStyle(
                                            color: Color(0xFF1A1C43),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward),
                                        const SizedBox(width: 5),
                                        Text(
                                          'To: ${item['at_drop']}',
                                          style: const TextStyle(
                                            color: Color(0xFF1A1C43),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Date: ${item['date']}',
                                      style: const TextStyle(fontSize: 11.5),
                                    ),
                                    Text(
                                      'Time: ${item['time']}',
                                      style: const TextStyle(fontSize: 11.5),
                                    ),
                                    Text(
                                      'Gender: ${item['rider_gender']}',
                                      style: const TextStyle(fontSize: 11.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                '${item['price']} THB',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        
        Expanded(child: bar()),
      ],
    );
  }

          // ปุ่มค้นหา
          Container(
            margin:
                const EdgeInsets.only(left: 120, right: 120), // กำหนด padding
            decoration: BoxDecoration(
              color: const Color(0xFF1A1C43), // สีพื้นหลัง
              borderRadius:
                  BorderRadius.circular(20), // ทำให้มุมของ container โค้ง
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    if (selectedPickup != null && selectedDrop != null) {
                      filterData(); // กรองข้อมูลใน listData
                    } else {
                      print('Please select Pickup and Drop,');
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedPickup = null; // รีเซ็ต Pickup
                      selectedDrop = null; // รีเซ็ต Drop
                      selectedOption = null; // รีเซ็ตเพศ
                      filteredList = listData; // แสดงข้อมูลทั้งหมดอีกครั้ง
                    });
                  },
                  icon: const Icon(Icons.refresh), // ใช้ไอคอนแทนข้อความ
                  color: Colors.red, // สีของไอคอน
                  tooltip: 'Reset', // ข้อความแสดงเมื่อ hover หรือกดปุ่มค้างไว้
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          //////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 110,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF1A1C43), // สีของเส้นขอบ
                      width: 1, // ความหนาของเส้นขอบ
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value:
                          selectedOption, // Set the value to the current selected option
                      hint: const Text('Gender'), // Placeholder text
                      items: selectOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedOption =
                              newValue; // Update selected value for the Select dropdown
                          filterData(); // เรียกใช้ฟังก์ชันกรองข้อมูลเมื่อเลือกเพศ
                        });
                      },
                      underline: Container(), // Hide underline
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xff1a1c43),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            debugPrint("Dashboard");
          },
          child: const Column(
            children: [
              Icon(
                Icons.home,
                size: 50.0,
              ),
              Text("Dashboard")
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xff1a1c43),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            debugPrint("Status");
          },
          child: const Column(
            children: [
              Icon(
                Icons.grading,
                size: 50.0,
              ),
              Text("Status")
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xff1a1c43),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            debugPrint("Profile");
          },
          child: const Column(
            children: [
              Icon(
                Icons.account_circle,
                size: 50.0,
              ),
              Text("Profile")
            ],
          ),
        ),
      ],
    );
  }
}
