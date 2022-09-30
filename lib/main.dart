import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mukurewini/helper/helper_functions.dart';
import 'package:mukurewini/shared/constants.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/views/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: _isSignedIn ? const HomeScreen() : const SignInScreen(),
    );
  }
}
