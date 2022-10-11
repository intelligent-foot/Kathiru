import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/views/showVet.dart';
import 'package:mukurewini/widgets/widgets.dart';

class MilkRecords extends StatefulWidget {
  //String userId;
  const MilkRecords({super.key});

  @override
  State<MilkRecords> createState() => _MilkRecordsState();
}

class _MilkRecordsState extends State<MilkRecords> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  QuerySnapshot? recordsSnapshot;
  DocumentSnapshot? userWakulimaSnapshot;
  User? username;
  String? name;
  String? email;
  double total = 0.0;
  double? firstAmount;
  double? secondAmount;
  double? difference;
  double price = 15.0;
  double? earnedAmount;
  int? farmerId;

  List<String> docIDs = [];

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text:
            'Your milk production levels seems to have dropped by $difference litres. This is a significant margin and could be caused by various issues with your cows. If this is the case we recommend that you visit our veterinary page and get help .\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(text: 'Thank You '),
        ],
      ),
    );
  }

  
  Widget _buildAboutDialog(BuildContext context) {
    // ignore: unnecessary_new
    return new AlertDialog(
      title: Text('Hello $name'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
          // _buildLogoAttribution(),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueAccent),
              ),
              child: const Text(
                'Ok, got it!',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: const Text('Contact Vet!'),
            ),
          ],
        ),
      ],
    );
  }

  Widget recordTile(
      {String? email,
      String? date,
      dynamic kilograms,
      int? farmerId,
      String? name}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: EdgeInsets.only(bottom: 10.0),
        height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/images/wakulima.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Center(
                  child: Text(
                    '$name',
                    // style: mediumTextStyle()
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    'Farmer Id: $farmerId',
                    // style: mediumTextStyle()
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    '  Date and time sold:\n$date',
                    // style: mediumTextStyle()
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    'Email: $email',
                    // style: mediumTextStyle(),
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Nunito-Regular',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    'Amount of Milk sold: $kilograms litres',
                    // style: mediumTextStyle(),
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    'Amount earned: ${kilograms * price} Kshs',
                    // style: mediumTextStyle(),
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Records')),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Cumulative amount of  Milk sold: $total litres",
                                  style: mediumTextStyle(),
                                ),
                                Text(
                                  "Amount Earned: $earnedAmount Kshs",
                                  style: mediumTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // recordList(),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC)
                                ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                "Go to Loans",
                                style: mediumTextStyle(),
                              ),
                            ),
                          ),
                        )
                      ]),
                );
              }),
        ),
      ),
    );
  }
}
