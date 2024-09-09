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

  final List<String> selectOptions = ['male', 'female']; // ตัวเลือกเพศ

  // ฟังก์ชันดึงข้อมูลจากเซิร์ฟเวอร์
  Future<void> fetchData() async {
    final String url = "http://192.168.1.110:8080/gotwo/post.php";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          listData = json.decode(response.body); // แปลง JSON เป็น List
          filteredList = listData; // เริ่มต้นให้ filteredList มีค่าเท่ากับ listData ทั้งหมด
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
        final matchesPickup = selectedPickup == null || item['pick_up'] == selectedPickup;
        final matchesDrop = selectedDrop == null || item['at_drop'] == selectedDrop;
        final matchesGender = selectedOption == null || item['rider_gender'] == selectedOption;

        return matchesPickup && matchesDrop && matchesGender;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(index),
      backgroundColor: Colors.white, // แสดงหน้าจอตาม index
      bottomNavigationBar: _buildBottomNavBar(), // แสดง Navigation Bar ด้านล่าง
    );
  }

  // ฟังก์ชันสร้างหน้าจอหลัก
  Widget _buildScreen(int index) {
    if (index == 0) {
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
          const SizedBox(height: 10),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text('No data found'), // หากไม่พบข้อมูลหลังการค้นหา
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Joindetail(item: item),
                            //   ),
                            // );
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ],
      );
    } else {
      return const TabbarCus();
    }
  }

  // ฟังก์ชันสร้าง Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.blue.shade100,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color(0xFF1A1C43),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist_outlined),
              selectedIcon: Icon(Icons.checklist),
              label: 'Status',
            ),
            NavigationDestination(
              icon: Icon(Icons.report_outlined),
              selectedIcon: Icon(Icons.report),
              label: 'Report',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับ Dropdown ที่ค้นหาได้
  Widget _dropdown_p() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          // Dropdown for Pickup
          DropdownSearch<String>(
            popupProps: PopupProps.dialog( // ใช้ PopupProps แทน mode
              showSearchBox: true, // เปิดช่องค้นหา
            ),
            items: pickupLocations, // รายการสถานที่
            onChanged: (value) {
              setState(() {
                selectedPickup = value;
              });
            },
            selectedItem: selectedPickup, // ค่าเริ่มต้นที่เลือก
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Pickup", // ข้อความแสดงในฟิลด์
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // การตกแต่งขอบ
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Dropdown for Drop
          DropdownSearch<String>(
            popupProps: PopupProps.dialog( // ใช้ PopupProps แทน mode
              showSearchBox: true, // เปิดช่องค้นหา
            ),
            items: dropLocations, // รายการสถานที่
            onChanged: (value) {
              setState(() {
                selectedDrop = value;
              });
            },
            selectedItem: selectedDrop, // ค่าเริ่มต้นที่เลือก
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Drop", // ใช้ที่นี่แทนการใช้ label
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // ปุ่มค้นหา
          ElevatedButton(
            onPressed: () {
              if (selectedPickup != null && selectedDrop != null) {
                filterData(); // กรองข้อมูลใน listData
              } else {
                print('Please select Pickup and Drop,');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1C43),
            ),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
