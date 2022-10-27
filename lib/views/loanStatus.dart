import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/widgets/widgets.dart';

class loanStatus extends StatefulWidget {
  String? userId;

  @override
  _loanStatusState createState() => _loanStatusState();
}

// ignore: camel_case_types
class _loanStatusState extends State<loanStatus> {
  final formKey = GlobalKey<FormState>();
  TextEditingController payLoanController = TextEditingController();
  TextEditingController payLoan2Controller = TextEditingController();
  TextEditingController previousMilkController = TextEditingController();
  TextEditingController cumulativeMilkController = TextEditingController();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  QuerySnapshot? recordsSnapshot;

  User? username;
  String name = 'joseph';
  String? email;
  double total = 0.0;

  /* Widget recordList() {
    return  
    recordsSnapshot != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: recordsSnapshot!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return recordTile(
                      loan:
                       recordsSnapshot!.docs[index].get('loan'),
                      loanStatus:
                          recordsSnapshot!.docs[index].get("loan status"),
                      repayment:
                          recordsSnapshot!.docs[index].get("repayment period"),
                      repayableLoan:
                          recordsSnapshot!.docs[index].get("payableLoan"));
                }),
          )
        : Container(
            child:const Text('no loans'),
          );
  }
 */

  Widget recordList() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('loan').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState)
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return recordTile(
                      loan: data['loan'],
                      loanStatus: data['loan status'],
                      repayableLoan:
                          data['payableLoan'],
                      repayment:
                          data['repayment period'],
                    );
                  },
                );
        },
      ),
    );
  }

  initiateSearch() {
    databaseService.getFarmerLoanState().then((val) {
      setState(() {
        recordsSnapshot = val;
        print("this snapshot contains $recordsSnapshot");
      });
    });
  }

  Widget recordTile(
      {int? loan, String? loanStatus, int? repayment, int? repayableLoan}) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  'Loan applied: Ksh $loan',
                  // style: mediumTextStyle(),
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                'The status of the loan is: $loanStatus',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The repayment period of your loan is: $repayment months',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The amount you are going to repay is Ksh $repayableLoan ',
                // style: mediumTextStyle(),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget record2Tile(
      {int? loan, String? loanStatus, int? repayment, int? repayableLoan}) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-sacco.jpg',
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Center(
                child: Text(
                  'Loan applied: Ksh $loan',
                  // style: mediumTextStyle(),
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                'The status of the loan is: $loanStatus',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The repayment period of your loan is: $repayment months',
                // style: mediumTextStyle(),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                'The amount you are going to repay is Ksh $repayableLoan ',
                // style: mediumTextStyle(),
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();

    super.initState();
  }

  Future<dynamic> startTransaction(
      {required double amount, required String phone}) async {
    dynamic transactionInitialisation;
    //Wrap it with a try-catch
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: phone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https", host: "my-app.herokuapp.com", path: "/callback"),
          accountReference: "payment",
          phoneNumber: phone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "demo",
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("RESULT: " + transactionInitialisation.toString());
      return transactionInitialisation;
    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('Wakulima'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
             height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.topCenter,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("loan").snapshots(),
                builder: (context, snapshot) {
                  return Container(
                     padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          recordList(),
                          const SizedBox(
                            height: 50,
                          ),
                          // ignore: unnecessary_null_comparison
                          snapshot != null
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    return val!.isEmpty
                                        ? "Value cannot be empty"
                                        : null;
                                  },
                                  controller: payLoanController,
                                  style: simpleTextStyle(),
                                  decoration: const InputDecoration(
                                      hintText: 'Enter amount to pay',
                                      fillColor: Colors.white54,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green,
                                              width: 2.0))),
                                )
                              : const Text("You have no loans"),
                          const SizedBox(
                            height: 50,
                          ),
                          // ignore: unnecessary_null_comparison
                          snapshot != null /* &&
                                  snapshot!.docs.isNotEmpty */
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.green, spreadRadius: 3),
                                    ],
                                  ),
                                  child: TextButton(
                                    // elevation: 1,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        startTransaction(
                                            amount: double.parse(
                                                payLoanController.text),
                                            phone: "254713659502");
                                      }
                                    },
                                    child: const Text("Pay Loan"),
                                  ),
                                )
                              : const Text("You have no loans"),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.green, spreadRadius: 3),
                              ],
                            ),
                            child: TextButton(
                              //elevation: 1,
                              onPressed: () {
                                /* avigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            )); */
                              },
                              child: const Text("Other Loans"),
                            ),
                          )
                        ]),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
