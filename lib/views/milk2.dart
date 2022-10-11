import 'package:flutter/material.dart';

class MissedRecords extends StatefulWidget {
   String userName;
  String email;
   MissedRecords({Key? key, required this.email, required this.userName});

  @override
  State<MissedRecords> createState() => _MissedRecordsState();
}

class _MissedRecordsState extends State<MissedRecords> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}