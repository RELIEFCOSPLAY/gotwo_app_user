import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gotwo_app_user/a/cus_logout.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: IconButton(
  icon: Icon(Icons.logout),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogoutPage()),
    );
  },
),
    );
  }
}