import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/model/user.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/widgets/widgets.dart';

class manager extends StatefulWidget {
  @override
  _managerState createState() => _managerState();
}

class _managerState extends State<manager> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
   TextEditingController payLoanController = TextEditingController();
  DatabaseService databaseService = new DatabaseService();
  AuthService authService = new AuthService();

  QuerySnapshot? recordsSnapshot;
  User? username;
  String name = 'joseph';
  String? email;
  double total = 0.0;

  String? ids;

  FirebaseUser? _firebaseUser(User user) {
    return user != null ? FirebaseUser(userId: user.uid) : null;
  }

  Widget recordList() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                email: recordsSnapshot!.docs[index].get('email'),
                loan: recordsSnapshot!.docs[index].get('loan'),
                id: recordsSnapshot!.docs[index].get('id'),
                bal: recordsSnapshot!.docs[index].get('bal'),
                paid: recordsSnapshot!.docs[index].get('paid')
              );
            })
        : Container();
  }

  Widget loanList() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 100.0,
                  child: recordsSnapshot!.docs[index].get('loan status') ==
                          "approved"
                      ? Icon(Icons.check)
                      : TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent)),
                          child: Text('approve'),
                          // color: Colors.blueAccent,
                          // textColor: Colors.white,
                          onPressed: () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            final FirebaseFirestore _firestore =
                                FirebaseFirestore.instance;
                            User user = await _auth.currentUser!;
                            FirebaseFirestore.instance
                                .collection("loan")
                                .doc(recordsSnapshot!.docs[index].get('id'))
                                .update(
                              {
                                "loan status": "approved",
                              },
                            );
                            final snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('loan approved successfully'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ),
                ),
              );
            })
        : Container();
  }





  Widget loanList2() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 100.0,
                  child: recordsSnapshot!.docs[index].get('loan status') ==
                          "denied"
                      ? Icon(
                          Icons.close,
                          color: Colors.red,
                        )
                      : TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.redAccent)),
                          child: Text('Deny'),
                          // color: Colors.redAccent,
                          // textColor: Colors.white,
                          onPressed: () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            final FirebaseFirestore _firestore =
                                FirebaseFirestore.instance;
                            User user = await _auth.currentUser!;
                            FirebaseFirestore.instance
                                .collection("loan")
                                .doc(recordsSnapshot!.docs[index].get('id'))
                                .update({
                              "status": "denied",
                            });
                            final snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('loan denied'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ),
                ),
              );
            })
        : Container();
  }

  Widget ClearLoan() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 100.0,
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),

                    child: Text(
                      'Clear',
                    ),

                    //   textColor: Colors.white,
                    onPressed: () async {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final FirebaseFirestore _firestore =
                          FirebaseFirestore.instance;
                      User user = await _auth.currentUser!;
                      FirebaseFirestore.instance
                          .collection("loan")
                          .doc(recordsSnapshot!.docs[index].get('id'))
                          .delete();
                    },
                  ),
                ),
              );
            })
        : Container();
  }

  

  initiateSearch() {
    databaseService.getAllUserLoans().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  Widget recordTile({String? email, String? loan, dynamic id, int? paid, int? bal}) {
    return Column(
      children: [
        Container(
          height: 100.0,
          child: Card(
            child: Center(
              child: Text(
                '$email\nFarmer Id: $id\nLoan requested: Ksh $loan\nAmount paid: $paid\n Balance: $bal',

                // style: mediumTextStyle(),
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget recordTile2({String? email, int? loan, dynamic id}) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Card(
          child: Text('$email'),
        ),
        Card(
          child: Text('Loan requested: Ksh $loan'),
        ),
      ],
    );
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: (() {
              nextScreen(context,  HomeScreen(userId: '',));
            })),
        title: Text('Farmers Loans'),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: ListTile(
            title: GestureDetector(
                onTap: () {
                  /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => otherLoans())); */
                },
                child: Text('other loans')),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("loan").snapshots(),
              builder: (context, snapshot) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 160.0,
                      child: recordList(),
                    ),
                    Container(
                      width: 160.0,
                      child: loanList(),
                    ),
                    Container(
                      width: 160.0,
                      child: loanList2(),
                    ),
                    Container(
                      width: 160.0,
                      child: ClearLoan(),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
