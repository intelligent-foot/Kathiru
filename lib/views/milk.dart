import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/widgets/widgets.dart';
import 'package:date_format/date_format.dart';

class MilkAgent extends StatefulWidget {
  String name;
  String email;
  String farmerId;
  MilkAgent(
      {Key? key,
      required this.email,
      required this.farmerId,
      required this.name})
      : super(key: key);

  @override
  State<MilkAgent> createState() => _MilkAgentState();
}

class _MilkAgentState extends State<MilkAgent> {
  //late String email;
  String name = 'Joseph';
  // String? uid;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController todayMilkController = TextEditingController();
  TextEditingController previousMilkController = TextEditingController();
  TextEditingController cumulativeMilkController = TextEditingController();
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
    String userId;
    String? userName;
    final user = await _auth.currentUser!;
    setState(() {
      email = user.email;
      userId = user.uid;
      userName = user.displayName;
      print(email);
      print(userId);
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

  /* Widget recordList() {
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
                 
                name: recordsSnapshot!.docs[index].get('fullName'),
                kilograms: recordsSnapshot!.docs[index].get('kilograms'),
                date: recordsSnapshot!.docs[index].get('date'),
              );
            },
          );
    //  },
    // );
  } */

  Widget recordList() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('farmers').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return recordTile(
                        id: data['farmerId'],
                        name: data['name'],
                        date: data['date'],
                        kilograms: data['kilograms']);
                  },
                );
        },
      ),
    );
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
      print('done');
      print('Name is ${widget.name}');
      print('location is ${selected}');
      print('kilograms is ${todayMilkController.text}');
      print('date is ${DateFormat.yMd().add_jm().format(DateTime.now())}');
      print('farmerId is ${widget.farmerId}');
      print('email is ${widget.email}');

      Map<String, dynamic> UserInfoMap = {
        "email": widget.email,
        "date": DateFormat.yMd().add_jm().format(DateTime.now()),
        "kilograms": double.tryParse(todayMilkController.text),
        "farmerId": widget.farmerId,
        "name": widget.name,
        "location": selected,
        
        //"servedBy": userSnapshot!["name"],
      };

      databaseService.uploadMilkInfo(UserInfoMap);
      const snackBar = SnackBar(
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
        title: const Text('Wakulima'),
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
                        .collection("farmers")
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
                                        gradient: const LinearGradient(colors: [
                                          Color(0xff007EF4),
                                          Color(0xff2A75BC)
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return val!.isEmpty
                                          ? "Cannot be empty"
                                          : null;
                                    },
                                    initialValue:
                                        "Email: ${widget.email} ",
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
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
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
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
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      if (double.tryParse(val!)! > 120) {
                                        return "Value is cannot be more than 100";
                                      }
                                      if (val.isEmpty) {
                                        return "Value cannot be empty";
                                      }
                                      return null;
                                    },
                                    controller: todayMilkController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
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
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  displayBoard(),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                //  recordList(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            /*   TextFormField(
                              readOnly: true,
                              validator: (val) {
                                return val!.isEmpty ? "Cannot be empty" : null;
                              },
                              initialValue: "Served By: ",
                              style:const TextStyle(color: Colors.black),
                              decoration:const InputDecoration(
                                  fillColor: Colors.white54,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.pink, width: 2.0))),
                            ), */
                            const SizedBox(
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
                                  print('Milk is ${todayMilkController.text}');
                                  print('location is ${selected}');

                                  todayMilkController.clear();
                                  print('done');
                                  print('Milk is ${todayMilkController.text}');
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
                            const SizedBox(
                              height: 50,
                            ),

                            const SizedBox(
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
