import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/model/user.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/views/loan.dart';
import 'package:mukurewini/views/showVet.dart';
import 'package:mukurewini/widgets/widgets.dart';
import 'dart:developer';

class Records extends StatefulWidget {
  String userId;
  Records({super.key, required this.userId});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  QuerySnapshot? recordsSnapshot;
  DocumentSnapshot? userSnapshot;
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

  FirebaseUser? _firebaseUser(User user) {
    return user != null ? FirebaseUser(userId: user.uid) : null;
  }
  //List<String> docIDs = [];

  Widget recordList() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (( BuildContext context,AsyncSnapshot<QuerySnapshot>  snapshot) {
             if (!snapshot.hasData) return const Text('Loading...');
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Container()
                : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                
                  physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return recordTile(
                        email: data['email'],
                        name: data['fullName'],
                        farmerId: data['uid']
                      );
                    }));
          })),
    );
    /* 
    /*  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) { */
    return recordsSnapshot != null
        ? Container()
        : ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  recordsSnapshot!.docs[index].data() as Map<String, dynamic>;
              return recordTile(
                email: data['email'],
                farmerId: data['uid'],
                name: data['fullName'],
              //  kilograms: data['kilograms'],
                date: data['date'],
               // log('data: $data');
              );
              
            },
          );

          
    //  },
   
    // );
 */
  }

  Future queryValues() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser!;
    FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: user.email)
        .get()
        .then((val) {
      double tempTotal =
          val.docs.fold(0, (tot, doc) => tot + doc.get('kilograms'));
      setState(() {
        total = tempTotal;
        earnedAmount = total * price;
      });
      debugPrint(total.toString());
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"cummulativeRecords": total});
    });
  }

  recommendVet() {
    if (difference! >= 5) {
      print('contact a vet');
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildAboutDialog(context),
      );
    }
  }

  initiateSearch() {
    DatabaseService.getFarmerRecordsByEmail().then((val) {
      setState(() {
        recordsSnapshot = val;
        firstAmount = recordsSnapshot!.docs[0].get('kilograms');
        secondAmount = recordsSnapshot!.docs[1].get('kilograms');

        difference = (secondAmount! - firstAmount!);
        name = recordsSnapshot!.docs[1].get('fullName');
        farmerId = recordsSnapshot!.docs[0].get('uid');
        recommendVet();
      });
    });
  }

  Widget _buildAboutText() {
    return RichText(
      text: TextSpan(
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
    return AlertDialog(
      title: Text('Hello $name'),
      content: Column(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
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

  @override
  void initState() {
    initiateSearch();

    super.initState();
    queryValues();
  }

  Widget recordTile(
      {String? email,
     // String? date,
      // dynamic kilograms,
      String? farmerId,
      String? name}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: EdgeInsets.only(bottom: 10.0),
        height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
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
                    'Farmer Id: $farmerId ',
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
                const Center(
                  child: Text(
                    '  Date and time sold:',
                    // style: mediumTextStyle()
                    style: TextStyle(
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
                      // fontFamily: 'Nunito-Regular',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Center(
                  child: Text(
                    'Amount of Milk sold:  litres',
                    // style: mediumTextStyle(),
                    style: TextStyle(
                      fontSize: 17.0,
                      // fontFamily: 'Nunito',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    'Amount earned: ${0 * price} Kshs',
                    // style: mediumTextStyle(),
                    style: const TextStyle(
                      fontSize: 17.0,
                      // fontFamily: 'Nunito',
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
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

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

                          recordList(),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loans(
                                          farmerId: '',
                                          name: '',
                                          total: 23,
                                        )));
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
