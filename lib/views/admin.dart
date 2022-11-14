import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/views/users.dart';

class Admin extends StatefulWidget {
  const Admin({super.key, Key , required this.user});
  final User user;

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String? userId;
  void _getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user!.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Admin page'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong.');
            // return Container();
          } else if (snapshot.hasData) {
            return checkRole(snapshot.data!);
            // snapshot.hasData ? checkRole(snapshot.data) :Container();
            // return Text(snapshot.data['email']);
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }

  Center checkRole(DocumentSnapshot snapshot) {
  
    // ignore: unnecessary_null_comparison
    if (snapshot.data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot['admin'] == true) {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  Center adminPage(DocumentSnapshot snapshot) {
    return Center(
        child: TextButton(
      child: const Text(
        'Go to Dairy', style: TextStyle(color:Colors.blue ),
        ),
      //color: Colors.blue,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  Users(userId: '',)));
      },
    ));
  }

  Center userPage(DocumentSnapshot snapshot) {
    return const Center(child: Text("You are not an admin"));
  }
}