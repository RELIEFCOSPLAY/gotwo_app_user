import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/tabbarcus/confirm_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/pending_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/success_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/totravel_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/cancel_tab.dart';
import 'package:gotwo_app_user/m2/join.dart';

class TabbarCus extends StatefulWidget {
  const TabbarCus({super.key});

  @override
  State<TabbarCus> createState() => _TabbarCusState();
}

class _TabbarCusState extends State<TabbarCus> {
  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ปิดการแสดงลูกศรย้อนกลับอัตโนมัติ
          title: Stack(
            children: [
             const Center(
                child: Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xff1a1c43),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xff1a1c43)),
                  onPressed: () {
                   Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>const Join()), // หน้าที่คุณต้องการย้อนกลับไป
      (Route<dynamic> route) => false,
    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              labelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              labelColor: Color(0xff1a1c43),
              indicatorColor: Color(0xff1a1c43),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Confirm",
                ),
                Tab(
                  text: "ToTravel",
                ),
                Tab(
                  text: "Success",
                ),
                Tab(
                  text: "Cancel",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      PendingTab(),
                    ],
                  ),
                  Column(
                    children: [
                      ConfirmTab(),
                    ],
                  ),
                  Column(
                    children: [
                      TotravelTab(),
                    ],
                  ),
                  Column(
                    children: [
                      SuccessTab(),
                    ],
                  ),
                  Column(
                    children: [
                      CancelTab(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
