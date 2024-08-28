import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:gotwo_app_user/a/tabbarcus/pending_tab.dart';
=======
import 'package:gotwo_app_user/a/cus_cancel.dart';
>>>>>>> 7aa57847a3739838d7eb8f814376abf6f85473ba
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/m2/bank.dart';
import 'package:gotwo_app_user/m2/home.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/join.dart';
import 'package:gotwo_app_user/m2/login.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/payment.dart';
import 'package:gotwo_app_user/m2/test.dart';

// ignore: unused_import

// import 'package:gotwo_app_user/m/bank.dart';
// // ignore: unused_import
// import 'package:gotwo_app_user/m/join.dart';
// // ignore: unused_import
// import 'package:gotwo_app_user/m/pickup.dart';
// // ignore: unused_import
// import 'package:gotwo_app_user/m/register.dart';
// import 'package:flutter_application_1/m/join.dart';
// import 'package:flutter_application_1/m/page1.dart';
// import 'package:flutter_application_1/m/pickup.dart';
// import 'package:flutter_application_1/m/register.dart';
// import 'package:flutter_application_1/m/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: Join(),
=======
      home:  TabbarCus(),
>>>>>>> 7aa57847a3739838d7eb8f814376abf6f85473ba
    );
  }
}
