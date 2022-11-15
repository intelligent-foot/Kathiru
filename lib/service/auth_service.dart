import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mukurewini/helper/helper_functions.dart';
import 'package:mukurewini/model/user.dart';
import 'package:mukurewini/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//login

  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return (e).message;
    }
  }

  FirebaseUser? _firebaseUser(User user) {
    return user != null ? FirebaseUser(userId: user.uid) : null;
  }

//register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password, String role) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our db service to update the user data
        await DatabaseService(uid: user.uid).savingUserData(
          fullName,
          email,
          role
          
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return (e).message;
    }
  }

//signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
