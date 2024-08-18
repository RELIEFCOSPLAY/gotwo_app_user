import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<Map<String, String>> listData = [
    {
      'from': 'home',
      'to': 'F1',
      'date': '24/03/24',
      'time': '10:30',
      'gender': 'Male',
      'price': '50 THB',
      'image': 'assets/images/profile.png',
      'id': 'ID1',
    },
    {
      'from': 'School',
      'to': 'F2',
      'date': '25/03/24',
      'time': '11:30',
      'gender': 'Male',
      'price': '35 THB',
      'image': 'assets/images/profile.png',
      'id': 'ID2',
    },
    {
      'from': 'JJ',
      'to': 'F3',
      'date': '25/03/24',
      'time': '18:30',
      'gender': 'Male',
      'price': '40 THB',
      'image': 'assets/images/profile.png',
      'id': 'ID3',
    },
    {
      'from': 'JJ',
      'to': 'F3',
      'date': '25/03/24',
      'time': '18:30',
      'gender': 'Male',
      'price': '47 THB',
      'image': 'assets/images/profile.png',
      'id': 'ID4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Color(0xFF1A1C43),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: listData.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    ////////////////////////////////////////////////////////////
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: AlertDialog(
                                title:const Center(
                                  child: Text(
                                    'QR Code',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                content: Container(
                                  width: 200.0,
                                  height: 250.0,
                                  child: QrImageView(
                                    data: item['price']!,
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                ),
                              
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, 
                                    children: [
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                            
                                            },
                                            label: const Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors
                                                      .white), 
                                            ),
                                            icon: const Icon(
                                              Icons.download,
                                              color: Colors.white,
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                const Color(0xFF1A1C43),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                         
                                        },
                                        icon: const Icon(Icons
                                            .add_photo_alternate), 
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                            'Close'), 
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      //////////////////////////////////////////////////////////
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A1C43),
                        elevation: 2,
                        minimumSize: const Size(300, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFF1A1C43),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: AssetImage(
                                    item['image'] ??
                                        'assets/images/profile.png',
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'From: ',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${item['from']}',
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Text(
                                            'To: ',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${item['to']}',
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Date: ${item['date']}',
                                        style: const TextStyle(fontSize: 11.5),
                                      ),
                                      Text(
                                        'Time: ${item['time']}',
                                        style: const TextStyle(fontSize: 11.5),
                                      ),
                                      Text(
                                        'Gender: ${item['gender']}',
                                        style: const TextStyle(fontSize: 11.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Text(
                                '${item['price']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
