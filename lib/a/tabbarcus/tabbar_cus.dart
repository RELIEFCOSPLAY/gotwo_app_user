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
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                       child: _backButton(context),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 80),
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff1a1c43),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                  text: "ToTravel ",
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
                    //Request
                    children: [
                      PendingTab(),
                    ],
                  ),
                  Column(
                    //Confirm
                    children: [
                      ConfirmTab(),
                    ],
                  ),
                  Column(
                    //To travel
                    children: [
                      TotravelTab(),
                    ],
                  ),
                  Column(
                    //Success
                    children: [
                      SuccessTab(),
                    ],
                  ),
                  Column(
                    //Cancel
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
  }Widget _backButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.arrow_back, color: Color(0xff1a1c43)),
    onPressed: () {
   Navigator.push(context, MaterialPageRoute(builder: (context) => Join())); // นำทางไปยังหน้าชื่อ Status
    },
  );
}

}

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        debugPrint("back");
      },
      child: const Icon(
        Icons.arrow_back_ios,
        size: 30,
        color: Color(0xff1a1c43),
      ),
    );
    
  }

