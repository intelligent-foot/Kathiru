import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/widgets/widgets.dart';
import 'package:date_format/date_format.dart';

class MilkAgent extends StatefulWidget {
  String name;
  String email;
  String uid;
  MilkAgent(
      {Key? key, required this.email, required this.uid, required this.name});

  @override
  State<MilkAgent> createState() => _MilkAgentState();
}

class _MilkAgentState extends State<MilkAgent> {
  //late String email;
  String name = 'Joseph';
  // String? uid;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  AuthService authService = AuthService();
  String? selected;
  bool isLoading = false;
  String? userName;
  DocumentSnapshot? userSnapshot;
  QuerySnapshot? recordsSnapshot;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //String name = 'Joseph';
  String? username;
  DatabaseService databaseService = DatabaseService();

  void initState() {
    getUserEmail();
    checkAgentName();
    super.initState();
  }

  getUserEmail() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String? email;
    String uid;
    String? userName;
    final user = await _auth.currentUser!;
    setState(() {
      email = user.email;
      uid = user.uid;
      userName = user.displayName;
      print(email);
      print(uid);
      print(userName);
    });
  }

  initiateSearch() {
    DatabaseService.getFarmerRecordsByEmail().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  checkAgentName() async {
    User? user = await _auth.currentUser;

    databaseService.getUserName().then((val) {
      setState(() {
        userSnapshot = val;
      });
    });
  }

  Widget recordList() {
    /*  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) { */
    return recordsSnapshot != null
        ? Container()
        : ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                id: recordsSnapshot!.docs[index].get('uid'),
                // farmerId: recordsSnapshot!.docs[index].get('uid'),
                name: recordsSnapshot!.docs[index].get('fullName'),
                kilograms: recordsSnapshot!.docs[index].get('kilograms'),
                date: recordsSnapshot!.docs[index].get('date'),
              );
            },
          );
    //  },
    // );
  }

  Widget recordTile(
      {required String id,
      required String name,
      required String date,
      dynamic kilograms}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$date',
                style: mediumTextStyle(),
              ),
              Text(
                '$name',
                style: mediumTextStyle(),
              ),
              Text(
                '$kilograms',
                style: mediumTextStyle(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget displayBoard() {
    List items = ["Kaheti", "Thunguri", "Karima", "Mukurweini-west"];
    // String? selectedItem = items[0];
    List<DropdownMenuItem> menuItemList = items
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.blueAccent, spreadRadius: 3),
          ],
        ),
        child: Card(
          child: DropdownButtonFormField(
            value: selected,
            validator: (value) =>
                value == null ? 'Please select location' : null,
            onChanged: (val) => setState(() => selected = val),
            items: menuItemList,
            hint: Text("choose location"),
          ),
        ),
      ),
    );
  }

  /*  saveFarmerMilk() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = await _auth.currentUser!;
    // call the db service
    DatabaseService.uploadMilkInfo(uid, user.email,
        DateTime.now().toIso8601String(), int.parse(todayMilkController.text));
    todayMilkController.clear();
  } */

  submitMilk() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      User? user = await _auth.currentUser;

      FirebaseFirestore.instance.collection("users").doc(user!.uid).set(
        {
          "email": widget.email,
          "date": new DateFormat.yMd().add_jm().format(DateTime.now()),
          "kilograms": double.parse(todayMilkController.text),
          "farmerId": widget.uid,
          "name": widget.name,
          "location": selected,
          "servedBy": userSnapshot!["name"],
        },
      );
      //databaseService.uploadMilkInfo(UserInfoMap);
      final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Milk recorded successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Wakulima'),
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Form(
                              key: formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          const Color(0xff007EF4),
                                          const Color(0xff2A75BC)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        formatDate(DateTime.now(), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                          ' ',
                                          HH,
                                          ':',
                                          nn
                                        ]),
                                        style: mediumTextStyle(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return val!.isEmpty
                                          ? "Cannot be empty"
                                          : null;
                                    },
                                    initialValue: "Farmer ID: ${widget.uid}   ",
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink,
                                                width: 2.0))),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return val!.isEmpty
                                          ? "Cannot be empty"
                                          : null;
                                    },
                                    initialValue: widget.name,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white54,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink,
                                                width: 2.0))),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      if (double.parse(val!) > 120)
                                        return "Value is cannot be more than 100";
                                      if (val.isEmpty)
                                        return "Value cannot be empty";
                                      return null;
                                    },
                                    controller: todayMilkController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: 'Today Milk Litres Sold',
                                        fillColor: Colors.white54,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2.0))),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  displayBoard(),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  // recordList(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              readOnly: true,
                              validator: (val) {
                                return val!.isEmpty ? "Cannot be empty" : null;
                              },
                              initialValue: "Served By: ",
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.white54,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.pink, width: 2.0))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                // saveFarmerMilk();
                                setState(() {
                                  print("isloading");
                                  isLoading = true;
                                });
                                submitMilk();
                                setState(() {
                                  isLoading = false;
                                  //   print('Milk is ${todayMilkController.text}');
                                  //  print('location is ${selected}');

                                  todayMilkController.clear();
                                  //   print('done');
                                  //   print('Milk is ${todayMilkController.text}');
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
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
                                    "Update",
                                    style: mediumTextStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            //inputMilkMissedRecords(),
                          ],
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
