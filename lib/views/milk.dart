import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/widgets/widgets.dart';

class MilkRecords extends StatefulWidget {
  const MilkRecords({super.key});

  @override
  State<MilkRecords> createState() => _MilkRecordsState();
}

class _MilkRecordsState extends State<MilkRecords> {
  String email = "";
  String name = 'Joseph';
  late Int farmerId;
  final formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  AuthService authService = AuthService();
  late String selected;
  bool isLoading = false;
  String userName = '';

    Widget recordTile({required String id, required String name, required String date, dynamic kilograms}) {
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

Widget inputMilkMissedRecords({required String email}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MilkRecords( 
                      
                    )));
      },

        child: Container(
        alignment: Alignment.centerRight,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xff007EF4), const Color(0xff2A75BC)]),
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            "Input missed milk Records",
            style: mediumTextStyle(),
          ),
        ),
      ),
    );
  }

    Widget displayBoard() {
    List loan = ["Kaheti", "Thunguri", "Karima", "Mukurweini-west"];
    List<DropdownMenuItem> menuItemList = loan
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
    );
  }
}
