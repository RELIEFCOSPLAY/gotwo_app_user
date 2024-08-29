import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/cus_pending.dart';
import 'package:gotwo_app_user/a/tabbarcus/pending_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:searchfield/searchfield.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {

  int index = 0;

  final screens = [
    JoinScreen(), 
    TabbarCus(),
    // Report(), 
    // Profile(), 
  ];

  List<Map<String, String>> listData = [
    {
      'from': 'home',
      'to': 'F1',
      'date': '24/03/24',
      'time': '10:30',
      'gender': 'Male',
      'price': '50 THB',
      'image': 'assets/images/profile.png',
    },
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
      ),
    );
  }
} 

// ignore: must_be_immutable
class JoinScreen extends StatelessWidget {
    List<String> _items = ['Female', 'Male'];
  String? selectedItem;
  String? newValue;
  final List<Map<String, String>> listData = [
    {
      'from': 'home',
      'to': 'F1',
      'date': '24/03/24',
      'time': '10:30',
      'gender': 'Male',
      'price': '50 THB',
      'image': 'assets/images/profile.png',
    },
    // Other list data entries...
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
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
          const SizedBox(height: 10),

          _dropdown_p(),

          const Divider(
            color: Color(0xFF1A1C43),
            thickness: 1,
            height: 0.5,
          ),

          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF1A1C43),
              ),
              minimumSize: MaterialStateProperty.all(const Size(90, 30)),
            ),
            child: const Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1A1C43)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text(
                        "Gender",
                        style: TextStyle(fontSize: 11),
                      ),
                      value: newValue,
                      items: _items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // Handle gender selection
                      },
                      icon: const Icon(Icons.arrow_drop_down, size: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final item = listData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press for each item
                    },
                   style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A1C43),
                        elevation: 2,
                        minimumSize: const Size(300, 100),
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
                              item['image']!,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item['from']} - ${item['to']}',
                                  style: const TextStyle(
                                    color: Color(0xFF1A1C43),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${item['date']} ${item['time']}',
                                  style: const TextStyle(
                                    color: Color(0xFF1A1C43),
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  item['gender']!,
                                  style: const TextStyle(
                                    color: Color(0xFF1A1C43),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          item['price']!,
                          style: const TextStyle(
                            color: Color(0xFF1A1C43),
                            fontSize: 11,
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
      ),
    );
  }
}

Widget _dropdown_p(){
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
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
                          // Add more suggestions as needed
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
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
                          // Add more suggestions as needed
                        ].map((e) => SearchFieldListItem<String>(e)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
}
