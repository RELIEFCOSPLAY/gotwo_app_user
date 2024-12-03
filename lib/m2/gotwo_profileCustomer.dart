import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotwo_app_user/a/cus_logout.dart';
import 'package:gotwo_app_user/global_ip.dart';
import 'package:gotwo_app_user/m2/join.dart';
import 'package:http/http.dart' as http;

class GotwoProfileCus extends StatefulWidget {
  const GotwoProfileCus({super.key});

  @override
  State<GotwoProfileCus> createState() => _GotwoProfileCusState();
}

class _GotwoProfileCusState extends State<GotwoProfileCus> {
  List<dynamic> listData = [];
  final storage = const FlutterSecureStorage();
  String? emails;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadLoginInfo();
    fetchData();
  }

  Future<void> loadLoginInfo() async {
    String? savedEmail = await storage.read(key: 'email');
    setState(() {
      emails = savedEmail;
    });
    if (emails != null) {
      fetchUserId(emails!);
    }
  }

  Future<void> fetchUserId(String email) async {
    final String url =
        "http://${Global.ip_8080}/gotwo/getUserId_cus.php"; // URL API
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

  Future<void> fetchData() async {
    final String url = "http://${Global.ip_8080}/gotwo/profile_dataCus.php";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          listData = json.decode(response.body);
        });
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: listData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await fetchData(); // ดึงข้อมูลใหม่จากเซิร์ฟเวอร์
              },
              color: const Color(0xff1a1c43), // สีของวงกลม Refresh
              backgroundColor: Colors.white, // สีพื้นหลังของ RefreshIndicator
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  final item = listData[index];
                  String uid = item['regis_customer_id'];
                  String imgShow =
                      "http://${Global.ip_8080}/${item['img_profile'] ?? ''}";

                  // แสดงเฉพาะข้อมูลของผู้ใช้ที่ล็อกอินอยู่
                  if (userId.toString() ==
                      item['regis_customer_id'].toString()) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Card
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1C43),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: _backButton(),
                                ),
                                Column(
                                  children: [
                                    CircleAvatar(
                                      minRadius: 25,
                                      maxRadius: 40,
                                      backgroundColor: Colors.white,
                                      child: item['img_profile'] != null
                                          ? ClipOval(
                                              child: Image.network(
                                                imgShow,
                                                fit: BoxFit.cover,
                                                width: 70,
                                                height: 70,
                                              ),
                                            )
                                          : const Icon(Icons.person),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item['status_customer'] == 0 ||
                                                    item['status_customer'] ==
                                                        '0'
                                                ? "normal"
                                                : "unnormal",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: item['status_customer'] ==
                                                          0 ||
                                                      item['status_customer'] ==
                                                          '0'
                                                  ? Colors.green
                                                  : Colors
                                                      .red, // สีต่างกันสำหรับแต่ละสถานะ
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Wallet Section
                        // Card(
                        //   elevation: 2,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(16),
                        //     child: Row(
                        //       children: [
                        //         const Icon(Icons.account_balance_wallet,
                        //             size: 30, color: Colors.grey),
                        //         const SizedBox(width: 10),
                        //         const Text(
                        //           'Wallet',
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.black,
                        //           ),
                        //         ),
                        //         const Spacer(), // ใช้ Spacer ได้ที่นี่เพราะ Row มีขนาดแน่นอน
                        //         Text(
                        //           "${item['wallet'] ?? '0.00'} Baht",
                        //           style: const TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.black,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 5),
                        // Profile Details Section
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileDetailRow(
                                  icon: Icons.email,
                                  title: 'EMAIL',
                                  value: item['email'],
                                ),
                                const Divider(),
                                ProfileDetailRow(
                                  icon: Icons.phone,
                                  title: 'PHONE NUMBER',
                                  value: item['tel'],
                                ),
                                const Divider(),
                                ProfileDetailRow(
                                  icon: Icons.date_range,
                                  title: 'EXPIRATION DATE',
                                  value: item['number_bank'],
                                ),
                                const Divider(),
                                ProfileDetailRow(
                                  icon: Icons.admin_panel_settings,
                                  title: 'CONTACT ADMIN',
                                  value: '+66 999 45678',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                        // Logout Button
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogoutPage()),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            'Log out',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        debugPrint("back");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Join(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: const Icon(
        Icons.arrow_back_ios,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
