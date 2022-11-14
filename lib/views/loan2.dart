import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/views/loanStatus.dart';

class Loan2 extends StatefulWidget {
  final int total;
  const Loan2({super.key, required this.total});

  @override
  State<Loan2> createState() => _Loan2State();
}

class _Loan2State extends State<Loan2> {
  @override
  TextEditingController loanAmountController = new TextEditingController();

  var loanEligible;

  Map? applyLoan(int total) {
    Map? constraints = {};

    if (widget.total >= 500) {
      constraints = {"from": 3000, "to": 15000};
    } else if (widget.total >= 200) {
      constraints = {"from": 1000, "to": 5000};
    } else if (widget.total >= 1000) {
      constraints = {"from": 3000, "to": 30000};
    } else if (widget.total >= 1500) {
      constraints = {"from": 3000, "to": 45000};
    } else if (widget.total < 200) {
      constraints = {"from": 500, "to": 1000};
    } else {
      constraints = null;
    }
    return constraints;
  }

  Widget displayBoard() {
    List loan = [
      for (var i = loanEligible["from"]; i < loanEligible["to"] + 500; i += 500)
        i
    ];
    String? selectedItem = loan[0];

    List<DropdownMenuItem> menuItemList = loan
        .map((loan) => DropdownMenuItem(value: loan, child: Text(loan.toString())))
        .toList();
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
        child: Card(
          child: DropdownButtonFormField(
            value: selectedItem,
            validator: (value) =>
                value == null ? 'Please select loan amount' : null,
            onChanged: (val) => setState(() => selectedItem = val),
            items: menuItemList,
            hint:const Text("choose loan amount"),
          ),
        ),
      ),
    );
  }

  

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: <Widget>[
                  //  recordList(),
                    Center(
                        child: Text(
                            "Buy more shares to increase your loan limit")),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              child: Center(
                                  child: Text(
                                      " Eligible  amount of loan from: ${loanEligible["from"].toString()} ")),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                            child: Center(
                                child: Text(
                                    "To: ${loanEligible["to"].toString()} ")),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    displayBoard(),
                    SizedBox(height: 50),
                    Center(
                        child: Text(
                      "Choose the repayment period below",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )),

                    // slider(),
                    SizedBox(height: 50),
                    // confirmButton(),

                    // checkExistLoan(),
                    // Container(
                    //   margin: EdgeInsets.all(20),
                    //   child: FlatButton(
                    //     child: Text('submit'),
                    //     color: Colors.blueAccent,
                    //     textColor: Colors.white,
                    //     onPressed: () async {
                    //       setState(() {
                    //         isLoading = true;
                    //       });
                    //       print(selected);
                    //       submitLoan();
                    //       setState(() {
                    //         isLoading = false;
                    //       });
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: TextButton(
                        child: Text('check loan status', style: TextStyle(color: Colors.black),),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        
                        
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loanStatus()));
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

    
