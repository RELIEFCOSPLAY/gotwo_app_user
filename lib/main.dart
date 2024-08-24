import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/cus_cancel.dart';
import 'package:gotwo_app_user/a/cus_confirm1.dart';
import 'package:gotwo_app_user/a/cus_confirm2.dart';
import 'package:gotwo_app_user/a/cus_pending.dart';
import 'package:gotwo_app_user/a/cus_success.dart';
import 'package:gotwo_app_user/a/cus_totravel.dart';
import 'package:gotwo_app_user/a/tabbarcus/tabbar_cus.dart';
import 'package:gotwo_app_user/a/tabbarcus/pending_tab.dart';
import 'package:gotwo_app_user/a/tabbarcus/confirm_tab.dart';
import 'package:gotwo_app_user/gotwo_PostInfor.dart';
import 'package:gotwo_app_user/m/join.dart';
import 'package:gotwo_app_user/m/bank.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m/join.dart';

// ignore: unused_import
import 'package:gotwo_app_user/m/pickup.dart';
// ignore: unused_import
import 'package:gotwo_app_user/m/register.dart';
import 'package:gotwo_app_user/m/page1.dart';

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
      home: CusConfirm(),
    );
  }
}
