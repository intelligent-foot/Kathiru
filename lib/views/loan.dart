import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/loanStatus.dart';
import 'package:mukurewini/views/slider.dart';
import 'package:mukurewini/widgets/widgets.dart';

class Loans extends StatefulWidget {
  final int total;
  final String name;
  String farmerId;
  Loans(
      {Key? key,
      required this.farmerId,
      required this.name,
      required this.total});

  int get t {
    return total;
  }

  @override
  State<Loans> createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  int? selected;
  bool isLoading = false;

  late double period;
  late double payableLoan;
  late double paid;
  late double bal;
  String p = '';
  late int rate;
  late double interest;
  double _value = 50.0;
  double loanPeriod = 24.0;
  QuerySnapshot? recordsSnapshot;
  DocumentSnapshot? loanSnapshot;

  TextEditingController loanAmountController = TextEditingController();
  TextEditingController loanAppController = TextEditingController();
  TextEditingController payLoanController = TextEditingController();
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();

  var loanEligible;

  void initState() {
    getDetails();
    loanEligible = applyLoan(widget.total);
    // print(loanEligible);
    checkExistingLoan();
    //print(loanEligible["from"]);
    super.initState();
  }

  getDetails() {
    databaseService.getFarmerLoanRecord().then((val) {
      setState(() {
        recordsSnapshot = val;
      });
    });
  }

  checkExistingLoan() async {
    databaseService.getLoanDetails().then((val) {
      setState(() {
        loanSnapshot = val;
      });

      print("This is what is $loanSnapshot");
    });
  }

  Map? applyLoan(int total) {
    var constraints = {};

    if (widget.total >= 500) {
      constraints = {"from": 25000, "to": 30000};
    } else if (widget.total >= 200) {
      constraints = {"from": 15000, "to": 20000};
    } else if (widget.total >= 1000) {
      constraints = {"from": 35000, "to": 40000};
    } else if (widget.total >= 1500) {
      constraints = {"from": 45000, "to": 50000};
    } else if (widget.total < 200) {
      constraints = {"from": 5000, "to": 10000};
    } else {
      return null;
    }
    return constraints;
  }

  Widget loanBoard() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (val) {
              if (double.tryParse(val!)! > loanEligible['to']) {
                return "Value is cannot be more ${loanEligible['to'].toString()} ";
              }

              if (val.isEmpty) {
                return "Value cannot be empty";
              }
            },
            controller: loanAppController,
            onChanged: (value) {
              p = value;
              print('amount is ${p}');
            },
            style: TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                hintText: 'Choose loan amount..',
                fillColor: Colors.white54,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
          ),
        ],
      ),
    );
  }

  /* Widget displayBoard() {
    List loan = [
      for (var i = loanEligible['from']; i < loanEligible['to'] + 500; i += 500)
        i
    ]; */

  /* List<DropdownMenuItem> menuItemList = loan
        .map((val) => DropdownMenuItem(value: val, child: Text(val.toString())))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        child: Card(
          child: DropdownButtonFormField(
            value: selected,
            validator: (value) =>
                value == null ? 'Please select loan amount' : null,
            onChanged: (val) => setState(() => selected = val),
            items: menuItemList,
            hint: Text("choose loan amount"),
          ),
        ),
      ),
    );
  } */

  calculateInterest() {
    if (formKey.currentState!.validate()) {
      payableLoan = (double.parse(p) * 0.4 * loanPeriod / 24);

      print("loan period is ${loanPeriod}");
      print(payableLoan);
    }
  }

  calculatBal() {
    if (formKey.currentState!.validate()) {}
  }

  submitAnotherLoan() async {
    if (formKey.currentState!.validate()) {
      calculateInterest();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      User? user = await _auth.currentUser;
      FirebaseFirestore.instance
          .collection("additionalLoans")
          .doc(user!.uid)
          .set(
        {
          'id': user.uid,
          'name': widget.name,
          'farmerId': widget.farmerId,
          'email': user.email,
          'loan': loanAppController.text,
          'loan status': "inactive",
          'repayment period': loanPeriod.toInt(),
          'payableLoan': payableLoan.toInt(),
        },
      );
      final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Another loan submitted successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

/*    Widget recordList() {
    if (recordsSnapshot != null && recordsSnapshot!.docs == null)
      return CircularProgressIndicator();
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                  crb: recordsSnapshot!.docs[index].get("crb"),
                  shares: recordsSnapshot!.docs[index].get('shares'));
            })
        : Container();
  } */
  final currentUser = FirebaseAuth.instance;
  Widget recordList() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("uid", isEqualTo: currentUser.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return recordTile(crb: data['crb'], shares: data['shares']);
                  },
                );
        },
      ),
    );
  }

  Widget recordTile({String? crb, int? shares}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        width: 20.0,
        height: 170.0,
        alignment: Alignment.center,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo-sacco.jpg',
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Center(
                  child: Text(
                    'CRB status: $crb',
                    // style: mediumTextStyle(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Number of Shares bought in the sacco: $shares',
                    // style: mediumTextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loan1Status() {
    // if (loanSnapshot == null) return CircularProgressIndicator();
    // return loanSnapshot.data.containsKey("id")
    //     ?
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
        boxShadow: const [
          BoxShadow(color: Colors.blue, spreadRadius: 3),
        ],
      ),
      margin: const EdgeInsets.all(20),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        child: const Text(
          'check loan status',
          style: TextStyle(color: Colors.white),
        ),
        //color: Colors.blueAccent,
        //textColor: Colors.white,
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => loanStatus()));
        },
      ),
    );
    // : Container();
  }

  Widget slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blue[700],
        inactiveTrackColor: Colors.blue[100],
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: Colors.blueAccent,
        overlayColor: Colors.blue.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.blue[700],
        inactiveTickMarkColor: Colors.blue[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.blueAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        value: loanPeriod,
        min: 0,
        max: 24,
        divisions: 12,
        label: '${loanPeriod.toStringAsFixed(0)} months',
        onChanged: (value) {
          setState(
            () {
              loanPeriod = value;
              print("the loan period is ${loanPeriod}");
            },
          );
        },
      ),
    );
  }

  Widget confirmButton() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
          boxShadow: [
            BoxShadow(color: Colors.blue, spreadRadius: 3),
          ],
        ),
        child: TextButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            payableLoan = (double.parse(p) * 0.4 * loanPeriod / 24);
            final snackBar = SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                    'You have chosen a loan amount of $p\n You will pay back with an interest of Ksh ${payableLoan.ceil()} \nwithin a payment period of ${loanPeriod.toStringAsFixed(0)} months  \n Click submit to proceed with loan application'));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ));
  }

  Widget farmerEligibleLoan() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        height: 170.0,
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo-sacco.jpg',
                  ),
                ),
              ),
              const Divider(),
              const Expanded(
                child: Center(
                    child: Text("Buy more shares to increase your loan limit")),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Center(
                  child: Text(
                      " Eligible  amount of loan from: ${loanEligible["from"].toString()} "),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: Center(
                      child: Text("To: ${loanEligible["to"].toString()}"))),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkExistLoan() {
    if (loanSnapshot == null) return CircularProgressIndicator();
    return !loanSnapshot!.exists
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              boxShadow: const [
                BoxShadow(color: Colors.blue, spreadRadius: 3),
              ],
            ),
            child: TextButton(
              child: const Text(
                'submit',
                style: TextStyle(color: Colors.white),
              ),

              // color: Colors.blueAccent,
              // textColor: Colors.white,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                print(selected);
                submitLoan();
                setState(() {
                  isLoading = false;
                });
              },
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              boxShadow: const [
                BoxShadow(color: Colors.blue, spreadRadius: 3),
              ],
            ),
            child: TextButton(
              child: const Text(
                'submit another loan',
                style: TextStyle(color: Colors.white),
              ),
              /*  style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Colors.blueAccent)), */
              //  color: Colors.blueAccent,
              // textColor: Colors.white,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                print(selected);
                submitAnotherLoan();
                setState(() {
                  isLoading = false;
                });
              },
            ),
          );
  }

  submitLoan() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      print('done');
      payableLoan = double.parse(p) + (double.parse(p) * 0.4 * loanPeriod / 24);
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      User? user = await _auth.currentUser;
      FirebaseFirestore.instance.collection("loan").doc(user!.uid).set(
        {
          'id': user.uid,
          'name': widget.name,
          'farmerId': widget.farmerId,
          'email': user.email,
          'loan': loanAppController.text,
          'loan status': "inactive",
          'repayment period': loanPeriod.toInt(),
          'payableLoan': payableLoan.toInt(),
          'paid': 0,
          'bal': 0,
        },
      );
      loan();

      const snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Loan submitted successfully'));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text("Loan application"),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: Form(
            key: formKey,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("loan").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    children: <Widget>[
                      recordList(),

                      farmerEligibleLoan(),
                      const SizedBox(
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (double.tryParse(val!)! < 5000 ||
                                double.tryParse(val)! < 10000) {
                              return "Value is cannot be more than 100";
                            }
                            if (val.isEmpty) {
                              return "Value cannot be empty";
                            }
                            return null;
                          },
                          controller: loanAppController,
                          onChanged: (value) {
                            p = value;
                            print('amount is ${p}');
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: 'Choose loan amount..',
                              fillColor: Colors.white54,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0))),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Center(
                          child: Text(
                        "Choose the repayment period below",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                      //slider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.green, spreadRadius: 3),
                            ],
                          ),
                          height: 30.0,
                          child: Card(
                            child: SliderExample(
                              updateValue: (double value) {
                                loanPeriod = value;
                                print("value from another world is: $value");
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      confirmButton(),
                      const SizedBox(height: 30),
                      checkExistLoan(),

                      const SizedBox(
                        height: 20,
                      ),
                      loan1Status(),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  void loan() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('loan')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('loan') == '0') {
          submitLoan();
        } else {
          print('Document does not exist on the database');
        }
      }
    });
  }
}
