import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/views/users.dart';

import '../service/auth_service.dart';
import '../service/database_service.dart';
import '../widgets/widgets.dart';
import 'Vets.dart';
import 'chat.dart';
import 'farmer.dart';
import 'home.dart';
import 'manager.dart';
import 'milk.dart';
import 'profile_screen.dart';
import 'search.dart';
import 'signin.dart';

class Agent extends StatefulWidget {
  const Agent({super.key});

  @override
  State<Agent> createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  String email = "";
  String userName = "";
  DocumentSnapshot? userSnapshot;
  User? user;
  String myUsername = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  String? userid;

  int currentIndex = 0;
  final screens = [
    HomeScreen(
      userId: '',
    ),
    ProfileScreen(
      email: '',
      userName: '',
    ),
    const ChatScreen(),
  ];

  Widget userNam({required String name}) {
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
        height: 200.0,
        child: Card(
          elevation: 10,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    image: const AssetImage(
                      "assets/images/c1.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                  child: Text(
                'Welcome $name',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget userHome() {
    return myUsername != null
        ? Container(
            child: userNam(name: myUsername),
          )
        : Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  void _getdata() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    User? user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((userData) {
      setState() {
        myUsername = userData.data()!['fullName'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wakulima'), actions: [
        IconButton(
            onPressed: () {
              nextScreen(context, SearchScreen());
            },
            icon: Icon(Icons.search))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Bussiness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfileScreen(
                      userName: userName,
                      email: email,
                    ));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout ? '),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()),
                                    (route) => false);
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });
                authService.signOut().whenComplete(() {
                  nextScreenReplace(context, const SignInScreen());
                });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
            /*     ListTile(
              onTap: () {
                nextScreenReplace(context, manager());
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Admin",
                style: TextStyle(color: Colors.black),
              ),
            ), */
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(1), BlendMode.dstATop),
            image: AssetImage('assets/images/c2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              userHome(),
              Container(
                padding: EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Users(
                                      userId: '',
                                    )));
                      },
                      child: const Card(
                        elevation: 10,
                        child: Center(
                          child: Text(
                            'Dairy',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MilkAgent(
                                      email: '',
                                      name: '',
                                      farmerId: '',
                                    )));
                      },
                      child: const Card(
                        elevation: 10,
                        child: Center(
                          child: Text(
                            'Manager',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        const snackBar =
                            SnackBar(content: Text("You're not a farmer!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: const Card(
                        elevation: 10,
                        child: Center(
                          child: Text(
                            'Dairy Records',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterVet(
                                      name: '',
                                    )));
                      },
                      child: const Card(
                        elevation: 10,
                        child: Center(
                          child: Text(
                            'Veterinary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == 'manager') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => manager()));
        }
        if (documentSnapshot.get('role') == 'Milk Agent') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Agent()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const FarmerScreen()));
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}