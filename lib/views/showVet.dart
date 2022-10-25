import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/views/Admin.dart';
import 'package:mukurewini/views/home.dart';

class Vets extends StatefulWidget {
  final String name;
   Vets({super.key, required this.name});

  @override
  State<Vets> createState() => _VetsState();
}

class _VetsState extends State<Vets> {

  String? email;
  double total = 0.0;
  String? userId;

  
  checkRole(DocumentSnapshot snapshot) {
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Veterinary'),
            ),
            StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection('vet')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                    // return Container();
                  } else if (snapshot.hasData) {
                    //return checkRole(snapshot.data);
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Available Veterinaries'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          // alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("vet").snapshots(),
              builder: (context, snapshot) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        // recordTile(),
                      ]),
                );
              }),
        ),
      ),
    );
  }
}
