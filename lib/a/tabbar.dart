import 'package:flutter/material.dart';
class Tabbar extends StatelessWidget {
  const Tabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, 
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Pending"),
              ),
              Tab(child: Text("Confirm"),
              ),
              Tab(child: Text("To Travel"),
              ),
              Tab(child: Text("Success"),
              ),
              Tab(child: Text("Cancel"),
              ),
            ],
          ),
          title: const Text('Statussssssssssssssssssss'),
        ),
        body: TabBarView(
          children: [
            Container(
              color: const Color.fromARGB(255, 232, 230, 228),
              child: const Icon(Icons.home),
            ),
            Container(
              color: const Color.fromARGB(255, 232, 230, 228),
              child: const Icon(Icons.home),
            ),
            Container(
              color: const Color.fromARGB(255, 232, 230, 228),
              child: const Icon(Icons.home),
            ),
            Container(
              color:const Color.fromARGB(255, 232, 230, 228),
              child: const Icon(Icons.home),
            ),
            Container(
              color: const Color.fromARGB(255, 232, 230, 228),
              child: const Icon(Icons.home),
            ),
          ]
        ),
      ),
      );
  }
}