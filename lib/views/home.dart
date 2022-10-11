import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/helper/helper_functions.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/Admin.dart';
import 'package:mukurewini/views/MilkRecords.dart';
import 'package:mukurewini/views/Vets.dart';
import 'package:mukurewini/views/bottom.dart';
import 'package:mukurewini/views/chat.dart';
import 'package:mukurewini/views/loan.dart';
import 'package:mukurewini/views/milk.dart';
import 'package:mukurewini/views/profile_screen.dart';
import 'package:mukurewini/views/search.dart';
import 'package:mukurewini/views/signin.dart';
import 'package:mukurewini/views/users.dart';
import 'package:mukurewini/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = "";
  String userName = "";

  AuthService authService = AuthService();

  Widget userNam({required String name}) {
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
        height: 200.0,
        child: Card(
          elevation: 10,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    image: new AssetImage(
                      "assets/images/c1.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                  child: Text(
                'Welcome $name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    ProfileScreen(
      email: '',
      userName: '',
    ),
    ChatScreen(),
  ];

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
        items: [
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
            ListTile(
              onTap: () {
                nextScreenReplace(context, AdminScreen());
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Admin",
                style: TextStyle(color: Colors.black),
              ),
            ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Users()));
                    },
                    child: Card(
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
                              builder: (context) =>
                                  MilkAgent(email: '', userName: '',)));
                    },
                    child: Card(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MilkRecords()));
                    },
                    child: Card(
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
                    child: Card(
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
    );
  }
}
