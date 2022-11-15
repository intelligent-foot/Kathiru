import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/helper/helper_functions.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/views/manager_screen.dart';
import 'package:mukurewini/views/signin.dart';

import '../widgets/widgets.dart';
import 'agent.dart';
import 'farmer.dart';
import 'manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  int? randomNumber;
  AuthService authService = AuthService();
  var options = ['Farmer', 'Milk Agent'];
  var _currentItemSelected = "Farmer";
  var role = "Farmer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Wakulima",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("Create your account",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        Image.asset("assets/images/logo-sacco.jpg"),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Full Name",
                              hintText: 'Full Name',
                              prefix: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                              print(email);
                            });
                          },

                          // check validation
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              hintText: 'Email',
                              prefix: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              print(email);
                            });
                          },

                          // check validation
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Please provide a valid email";
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              hintText: 'Password',
                              prefix: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: ((value) {
                            return value!.length > 6
                                ? null
                                : "Please provide password 6+ characters";
                          }),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                              print(password);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Role : ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.blue[900],
                          isDense: true,
                          isExpanded: false,
                          iconEnabledColor: Colors.black,
                          focusColor: Colors.black,
                          items: options.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            setState(() {
                              _currentItemSelected = newValueSelected!;
                              role = newValueSelected;
                            });
                          },
                          value: _currentItemSelected,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Already have an account ? ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Sign In here",
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const SignInScreen());
                                  })
                          ],
                        ))
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password, role)
          .then((value) async {
        if (value == true) {
          //saving the shared pf state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserRoleSF(role);
          /* nextScreenReplace(
              context,
              HomeScreen(
                userId: '',
              )); */
          route();
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
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
              context, MaterialPageRoute(builder: (context) => ManagerScreen()));
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
