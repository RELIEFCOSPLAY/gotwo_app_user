import 'package:flutter/material.dart';

class CusConfirm extends StatefulWidget {
  const CusConfirm({Key? key}) : super(key: key);

  @override
  State<CusConfirm> createState() => _CusConfirmState();
}

class _CusConfirmState extends State<CusConfirm> {

  final Map<String, String> item = {
   
  'name': 'Name Lastname',  
    'to': 'F1',
    'date': '24/03/24',
    'gender': 'female',
    'price': '50 THB',
    'comment': 'comment',
    'image': 'assets/images/profile.png',
    'status': 'There is a helmet for you.',
    'status2': 'Bring your own a helmet.',
  };

  @override
  Widget build(BuildContext context) {
    // Selecting the first item from listData
    final Map<String, String> firstItem = item;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm',
          style: TextStyle(
            color: Color(0xFF1A1C43),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Image.asset(
                  firstItem['image'] ?? 'assets/images/profile.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 5),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Text(
                          '${firstItem['name']} ',
                          style: const TextStyle(
                            color: Color(0xFF1A1C43),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                    Icon(
                      firstItem['gender'] == 'Male' ? Icons.male : Icons.female,
                      color: const Color(0xFF1A1C43),
                      size: 15,
                    ),
                   ],
                 ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rate ',
                      style: TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                  ],
                ),
                
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF1A1C43),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${firstItem['date']}',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.payment,
                      color: Color(0xFF1A1C43),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${firstItem['price']} ',
                      style: const TextStyle(
                        color: Color(0xFF1A1C43),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1, // Border width
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Pickup',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.my_location,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${firstItem['from']}',
                                style: const TextStyle(
                                  color: Color(0xFF1A1C43),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            '${firstItem['comment']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Divider(
                            color: Color(0xFF1A1C43),
                            thickness: 0.5,
                            height: 1,
                            indent: 5,
                            endIndent: 30,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Drop',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              color: Color(0xFFD3261A),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${firstItem['to']}',
                                style: const TextStyle(
                                  color: Color(0xFF1A1C43),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            '${firstItem['comment']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Divider(
                            color: Color(0xFF1A1C43),
                            thickness: 0.5,
                            height: 1,
                            indent: 5,
                            endIndent: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  ' ${firstItem['status']}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 30),

                Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.green,
                        minimumSize: const Size(90, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Paid',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(90, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
               
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
