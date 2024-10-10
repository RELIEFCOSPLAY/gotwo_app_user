import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import dropdown_search
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/cus_logout.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:gotwo_app_user/m2/joindetail.dart';
import 'package:http/http.dart' as http;

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  int index = 0;
  List<dynamic> listData = [];
  List<dynamic> listCusId = [];
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

  final storage = const FlutterSecureStorage();
  String? emails;
  String? userId; // เก็บ ID ของผู้ใช้หลังจากดึงมา

  Future<void> loadLoginInfo() async {
    String? savedEmail = await storage.read(key: 'email');
    setState(() {
      emails = savedEmail;
    });
    if (emails != null) {
      fetchUserId(emails!); // เรียกใช้ API เพื่อตรวจสอบ user id
    }
  }

  // ฟังก์ชันดึงข้อมูลจากเซิร์ฟเวอร์
  Future<void> fetchData() async {
    final String url = "http://${Global.ip_80}/gotwo/join.php";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          listData = json.decode(response.body); // แปลง JSON เป็น List
          filteredList = listData;
        });
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  Future<void> fetchUserId(String email) async {
    final String url =
        "http://${Global.ip_80}/gotwo/getUserId_cus.php"; // URL API
    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email, // ส่ง email เพื่อค้นหา user id
      });


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            userId = data['user_id']; // เก็บ user id ที่ได้มา
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print("Failed to fetch user id");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // ดึงข้อมูลเมื่อเริ่มแอป
    loadLoginInfo();
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

      // แสดงข้อความแจ้งเตือนเมื่อไม่พบข้อมูล
      if (filteredList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No matching data found.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildScreen()), // เนื้อหา
          Align(
            alignment: Alignment.bottomCenter, // ชิดขอบด้านล่าง
            child: bar(), // แถบปุ่มด้านล่าง
          ),
        ],
      ),
      backgroundColor: Colors.white, // แสดงหน้าจอตาม index
    );
  }

  // ฟังก์ชันสร้างหน้าจอหลัก
  Widget _buildScreen() {
    return Column(children: [
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
                child: Text('No data found'),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];

                  // if (userId == item['customer_id'].toString()) {
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
                            Flexible(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/profile.png',
                                    height: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'From: ${item['pick_up']}',
                                                style: const TextStyle(
                                                  color: Color(0xFF1A1C43),
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                'To: ${item['at_drop']}',
                                                style: const TextStyle(
                                                  color: Color(0xFF1A1C43),
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Date: ${item['date']}',
                                          style:
                                              const TextStyle(fontSize: 11.5),
                                        ),
                                        Text(
                                          'Time: ${item['time']}',
                                          style:
                                              const TextStyle(fontSize: 11.5),
                                        ),
                                        Text(
                                          'Gender: ${item['rider_gender']}',
                                          style:
                                              const TextStyle(fontSize: 11.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                  // } else {
                  //   return const SizedBox.shrink();
                  // }
                },
              ),
      ),
    ]);
  }

  // ฟังก์ชันสำหรับ Dropdown ที่ค้นหาได้
  Widget _dropdown_p() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          // Dropdown for Pickup
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.dialog(
                        showSearchBox: true,
                      ),
                      items: pickupLocations,
                      onChanged: (value) {
                        setState(() {
                          selectedPickup = value;
                        });
                      },
                      selectedItem: selectedPickup,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Pickup",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 10), // Add some space between the dropdowns
                Expanded(
                  child: Container(
                    height: 50,
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.dialog(
                        showSearchBox: true,
                      ),
                      items: dropLocations,
                      onChanged: (value) {
                        setState(() {
                          selectedDrop = value;
                        });
                      },
                      selectedItem: selectedDrop,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Drop",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // ปุ่มค้นหา
          Container(
            margin:
                const EdgeInsets.only(left: 110, right: 110), // กำหนด padding
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please select both Pickup and Drop locations.'),
                        ),
                      );
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
          // Dropdown สำหรับการเลือกเพศ
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

  // แถบปุ่มด้านล่าง
  Widget bar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff1a1c43), // ตั้งค่า background ของแถบปุ่ม
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // โค้งมุมบนซ้าย
          topRight: Radius.circular(20), // โค้งมุมบนขวา
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8), // กำหนด padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // ไม่มีพื้นหลัง
              shadowColor: Colors.transparent, // ไม่มีเงา
              elevation: 0, // ยกเลิกการยกปุ่มขึ้น
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Join(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: const Column(
              children: [
                Icon(
                  Icons.home,
                  size: 30.0,
                  color: Colors.white,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          //////////////////////////
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // ไม่มีพื้นหลัง
              shadowColor: Colors.transparent, // ไม่มีเงา
              elevation: 0, // ยกเลิกการยกปุ่มขึ้น
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TabbarCus(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: const Column(
              children: [
                Icon(
                  Icons.grading,
                  size: 30.0,
                  color: Colors.white,
                ),
                Text(
                  "Status",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ///////////////////
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // ไม่มีพื้นหลัง
              shadowColor: Colors.transparent, // ไม่มีเงา
              elevation: 0, // ยกเลิกการยกปุ่มขึ้น
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogoutPage()),
              );
            },
            child: const Column(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 30.0,
                  color: Colors.white,
                ),
                Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
