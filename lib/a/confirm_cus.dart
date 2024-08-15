import 'package:flutter/material.dart';

class ConfirmCus extends StatefulWidget {
  const ConfirmCus({super.key});

  @override
  State<ConfirmCus> createState() => _ConfirmCusState();
}

class _ConfirmCusState extends State<ConfirmCus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}