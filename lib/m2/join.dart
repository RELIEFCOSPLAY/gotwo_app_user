import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/m2/test2.dart';
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

  // ตัวแปรสำหรับ DropdownButton
  String? selectedPickup; // เก็บค่าที่เลือกจาก Pickup
  String? selectedDrop; // เก็บค่าที่เลือกจาก Drop
  String? selectedOption; // ปรับเป็น null แทนค่าเริ่มต้นที่ไม่ถูกต้อง

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(index), 
      backgroundColor: Colors.white,// แสดงหน้าจอตาม index
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
            child: listData.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  ) // ถ้าข้อมูลว่างแสดง Loading
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      final item = listData[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

  // ฟังก์ชันสำหรับ Dropdown
  Widget _dropdown_p() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          // Existing Pickup and Drop section
          Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dropdown for Pickup
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 110),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedPickup,
                          hint: const Text('Pickup'),
                          items: pickupLocations.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedPickup = newValue; // Update Pickup value
                            });
                          },
                          underline: Container(), // Hide underline
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset('assets/images/motorcycle.png', height: 20),
                  const SizedBox(width: 15),
                  // Dropdown for Drop
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 110),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedDrop,
                          hint: const Text('Drop'),
                          items: dropLocations.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDrop = newValue; // Update Drop value
                            });
                          },
                          underline: Container(), // Hide underline
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // "Search" Button
          ElevatedButton(
            onPressed: () {
              if (selectedPickup != null && selectedDrop != null) {
                // Perform search operation when Search button is clicked and values are not null
                print('Searching from $selectedPickup to $selectedDrop');
              } else {
                print('Please select Pickup and Drop');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1C43),
            ),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 10),

          // Dropdown for "Select" aligned to the right
          Padding(
            padding:
                const EdgeInsets.only(right: 20), // Add padding to the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the right
              children: [
                Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // foregroundColor: const Color(0xFF1A1C43),
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
                      hint: const Text('Select'), // Placeholder text
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
}
