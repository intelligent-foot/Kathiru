import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/service/auth_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController emailController = TextEditingController();
  String email = "";
  String uid = "";
  String role = "";
AuthService authService = AuthService();

  //void initState() {
   // super.initState();
    //_checkRole();
 // }

 // void _checkRole() async {
   // User? user = FirebaseAuth.instance.currentUser;
    //final DocumentSnapshot snapshot = await FirebaseFirestore.instance
       // .collection('users')
        //.doc(user!.uid)
       // .get();

   // setState(() {
    //  role = snapshot['role'];
   // });

  //  if (role == 'user') {
     // nextScreen(context, HomeScreen());
   // } else if (role == 'admin') {
   //   nextScreen(context, AdminScreen());
   // }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(

            decoration: textInputDecoration.copyWith(
              
              hintText: 'Email',
              labelText: 'Email',
              prefix: Icon(Icons.email, color: Theme.of(context).primaryColor,),
            ),
            controller: emailController,
            
            
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () async {
              String userEmail = emailController.text.trim();
              final QuerySnapshot snapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: userEmail)
                  .get();
              setState(() {
                email = userEmail;
                uid = snapshot.docs[0]['uid'];
                 role = snapshot.docs[0]['role'];
                  

              });
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                
              ),
              child: Center(
                child: Text('Get User Data'),
              )
            ),
        
          ),
          const SizedBox(height: 10,),
          Center(
            child: Text('User Data :'),
          ),
          
          const SizedBox(height: 10
          ,),
          Center(
            child: Text('Email : ' + email),
          ),
          Center(
            child: Text('UID :' + uid),
          ),
           
            Center(
              child:  Text('Role :' + role),
            )
            ,

        ],
      )),
    );
  }
}
