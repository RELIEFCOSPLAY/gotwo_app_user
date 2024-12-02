import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Jenny Joy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet, size: 30),
                          SizedBox(width: 10),
                          Text(
                            'Wallet',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '140.00 Baht',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileDetailRow(
                      icon: Icons.email,
                      title: 'EMAIL',
                      value: 'me@gmail.com',
                    ),
                    Divider(),
                    ProfileDetailRow(
                      icon: Icons.phone,
                      title: 'PHONE NUMBER',
                      value: '+66 123 45678',
                    ),
                    Divider(),
                    ProfileDetailRow(
                      icon: Icons.date_range,
                      title: 'EXPIRATION DATE',
                      value: '10/12/2024',
                    ),
                    Divider(),
                    ProfileDetailRow(
                      icon: Icons.admin_panel_settings,
                      title: 'CONTACT ADMIN',
                      value: '+66 999 45678',
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: () {
                // Handle logout
              },
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text(
                'Log out',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
