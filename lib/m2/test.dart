import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:gotwo_app_user/m2/joindetail.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  int index = 0;

  final screens = [
    JoinScreen(),
    //TabbarCus(),  // เนื่องจากไม่มีข้อมูลสำหรับ TabbarCus ผมจะไม่ใช้งานในโค้ดนี้
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
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
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class JoinScreen extends StatelessWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JoinScreenList(); // เรียกใช้ JoinScreenList ที่ดึงข้อมูลจาก API
  }
}

class JoinScreenList extends StatefulWidget {
  @override
  _JoinScreenListState createState() => _JoinScreenListState();
}

class _JoinScreenListState extends State<JoinScreenList> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:54518/connec.php'));
      if (response.statusCode == 200) {
        // การคืนค่าเป็น Future ที่มีข้อมูล List ของ Map
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final listData = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 20),
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
                            builder: (context) =>
                                const Joindetail()), // ให้ NextPage() เป็นหน้าถัดไป
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A1C43),
                      elevation: 2,
                      minimumSize: const Size(350, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                              item['image'] ?? 'assets/images/profile.png',
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'From: ${item['from'] ?? 'Unknown'} ',
                                      style: const TextStyle(
                                        color: Color(0xFF1A1C43),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward),
                                    const SizedBox(width: 5),
                                    Text(
                                      'To: ${item['to'] ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: Color(0xFF1A1C43),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Date: ${item['date'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 11.5),
                                ),
                                Text(
                                  'Time: ${item['time'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 11.5),
                                ),
                                Text(
                                  'Gender: ${item['gender'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 11.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            '${item['price'] ?? 'N/A'} THB',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

Widget _dropdown_p() {
  return Container(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 20, 10),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 110),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: SearchField(
                hint: 'Pickup',
                searchInputDecoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                itemHeight: 35,
                maxSuggestionsInViewPort: 8,
                suggestionsDecoration: SuggestionDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0x9FC8DFF0),
                ),
                onSubmit: (String value) {
                  // Handle submission
                },
                suggestions: [
                  'F1',
                  'Central',
                  'Airport',
                  'Station',
                  'Mall',
                  'Park',
                  'University',
                  'Downtown',
                  'Hotel',
                  'Restaurant',
                ].map((e) => SearchFieldListItem<String>(e)).toList(),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Image.asset(
            'assets/images/motorcycle.png',
            height: 20,
          ),
          const SizedBox(width: 15),
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 110),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: SearchField(
                hint: 'Drop',
                searchInputDecoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                itemHeight: 35,
                maxSuggestionsInViewPort: 8,
                suggestionsDecoration: SuggestionDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0x9FC8DFF0),
                ),
                onSubmit: (String value) {
                  // Handle submission
                },
                suggestions: [
                  'F1',
                  'Central',
                  'Airport',
                  'Station',
                  'Mall',
                  'Park',
                  'University',
                  'Downtown',
                  'Hotel',
                  'Restaurant',
                ].map((e) => SearchFieldListItem<String>(e)).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
