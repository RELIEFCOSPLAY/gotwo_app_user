import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/cus_confirm1.dart';

class ConfirmTab extends StatefulWidget {
  @override
  State<ConfirmTab> createState() => _ConfirmTabState();
}

class _ConfirmTabState extends State<ConfirmTab> {
   int index = 0;

   List testDate = [
    {
      'from': 'home',
      'to': 'F1',
      'date': '24/03/24',
      'time': '10:30',
      'price': '50 ',
      'status': 'Unpaid',
    },
    {
      'from': 'School',
      'to': 'F2',
      'date': '25/03/24',
      'time': '11:30',
      'price': '35 ',
      'status': 'Unpaid',
    },
    {
      'from': 'JJ',
      'to': 'F3',
      'date': '25/03/24',
      'time': '18:30',
      'price': '40 ',
      'status': 'Paid',
    },
    {
      'from': 'Workplace',
      'to': 'F4',
      'date': '26/03/24',
      'time': '12:30',
      'price': '45 ',
      'status': 'Paid',
    },
    {
      'from': 'Gym',
      'to': 'F5',
      'date': '26/03/24',
      'time': '13:30',
      'price': '55 ',
      'status': 'Paid',
    },
    {
      'from': 'Park',
      'to': 'F6',
      'date': '27/03/24',
      'price': '60 ',
      'status': 'Unpaid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ConfirmTab(),
      ],
    );
  }

  Widget _ConfirmTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 320,
        height: 444,
        child: ListView.builder(
          itemCount: testDate.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
              child: SizedBox(
                width: 300,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => (CusConfirm())),
                   );
                  
                    debugPrint("CardRequest ${testDate[index]['from']}");
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0xfffbf8ff)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  const BorderSide(color: Color(0xff1a1c43))))),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                Row(
                                  children: [
                                    Text(
                                      "From: ${testDate[index]['from']}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 12, color: Color(0xff1a1c43)),
                                    ),
                                  ],
                                ),
                            Text(
                              "Date: ${testDate[index]['date']} ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff1a1c43)),
                            ),
                            Text(
                              "Time: ${testDate[index]['time']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff1a1c43)),
                            ),
                            Text(
                              "Status: ${testDate[index]['status']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff1a1c43)),
                            ),

                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.arrow_forward,
                            color: Color(0xff1a1c43)),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.tour,
                                  color: Color(0xff1a1c43),
                                  size: 20.0,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "To: ${testDate[index]['to']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xff1a1c43)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${testDate[index]['price']} ",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16, color: Color(0xff1a1c43)),
                                ),
                                const Text(
                                  "THB",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Color(0xff1a1c43)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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
}
