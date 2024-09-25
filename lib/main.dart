import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/cus_cancel.dart';
import 'package:gotwo_app_user/a/cus_pending.dart';
import 'package:gotwo_app_user/a/cus_totravel.dart';
import 'package:gotwo_app_user/a/cus_profilepage.dart';
import 'package:gotwo_app_user/a/tabbarcus/confirm_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/a/tabbarcus/totravel_tab.dart';
import 'package:gotwo_app_user/m2/bank.dart';
import 'package:gotwo_app_user/m2/check_loign.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/home.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/join.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/login.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m2/payment.dart';
import 'package:gotwo_app_user/a/cus_logout.dart';
import 'package:gotwo_app_user/m2/register.dart';
import 'package:gotwo_app_user/m2/test2.dart';
import 'package:http/http.dart' as http;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        appBarTheme:const AppBarTheme(
    backgroundColor: Colors.white)
      ),
      home: Loginpage(),
    );
  }
}
