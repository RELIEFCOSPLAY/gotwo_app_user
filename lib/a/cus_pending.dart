import 'package:flutter/material.dart';

class CusPending extends StatefulWidget {
  const CusPending({super.key});

  @override
  State<CusPending> createState() => _CusPendingState();
}

class _CusPendingState extends State<CusPending> {
  List testDate = [
    {
      'from': 'home',
      'to': 'F1',
      'date': '24/03/24',
      'time': '10:30',
      'price': '50 THB',
      'status': 'Unpaid',
    },
    {
      'from': 'School',
      'to': 'F2',
      'date': '25/03/24',
      'time': '11:30',
      'price': '35 THB',
      'status': 'Unpaid',
    },
    {
      'from': 'JJ',
      'to': 'F3',
      'date': '25/03/24',
      'time': '18:30',
      'price': '40 THB',
      'status': 'Paid',
    },
    {
      'from': 'Workplace',
      'to': 'F4',
      'date': '26/03/24',
      'time': '12:30',
      'price': '45 THB',
      'status': 'Paid',
    },
    {
      'from': 'Gym',
      'to': 'F5',
      'date': '26/03/24',
      'time': '13:30',
      'price': '55 THB',
      'status': 'Paid',
    },
    {
      'from': 'Park',
      'to': 'F6',
      'date': '27/03/24',
      'price': '60 THB',
      'status': 'Unpaid',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending'),
      ),
      body: Container(),
    );
  }
}
