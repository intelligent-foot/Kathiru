import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DatabaseService {
  final String? uid;

  int? randomNumber;
  /* Random random = Random();
  randomNumber = random.nextInt(5000)+100; */

  DatabaseService({this.uid});

// reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  CollectionReference vet = FirebaseFirestore.instance.collection('vet');
  CollectionReference milk = FirebaseFirestore.instance.collection('milk');
  //saving the userdata
  Future savingUserData(
    String fullName,
    String email,

    /*String Kilograms,String ServedBy*/
  ) async {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    // int randomNumber;
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
      "admin": false,

      'joinedAt': formattedDate,
      'createdAt': Timestamp.now(),
      "shares": 0,
      "crb": "cleared",
      "status": "online",
      "last_seen": DateFormat.yMd().add_jm().format(DateTime.now()),
      "agent": "false",
      "farmerId": randomNumber,
      "cumulative Records": 0,

      // "Kilograms": Kilograms,
      // 'ServedBy' : 'Joseph Kathiru'
    });
  }

// getting userdata

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
// upload milk info

  /* Future uploadMilkInfo(
      String uid, String name, String date, int kilograms, String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User user = await _auth.currentUser!;

    return await userCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'date': date,
      'kilograms': kilograms,
      
    }).catchError((e) {
      print(e.toString());
    });
  } */

// get farmer id
  getFarmerId(int id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: id)
        .get();
  }

  // get all users
  getAllUsers() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = await auth.currentUser!;
    return await FirebaseFirestore.instance.collection('users').get();
  }

  uploadVetInfo(userMap) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User user = await _auth.currentUser!;
    FirebaseFirestore.instance
        .collection('vet')
        .doc(user.uid)
        .set(userMap)
        .catchError((e) {
          print(e.toString());
        })
        .then((value) => print('Vet data added'))
        .catchError((error) => print("Vet couldn't be added"));
  }

  static Future getFarmerRecordsByEmail() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User user =  _auth.currentUser!;
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: user.email)
         .orderBy("date", descending: true)
        .get();
  }

  Future uploadMilkInfo(userMap) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User user = await _auth.currentUser!;
    FirebaseFirestore.instance
        .collection('farmers')
        .doc(user.uid)
        .set(userMap)
        .catchError((e) {
          print(e.toString());
        })
        .then((value) => print('Milk data added'))
        .catchError((error) => print("Milk couldn't be added"));
  }

  getAllUserLoans() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User user = await _auth.currentUser!;
    return await FirebaseFirestore.instance.collection("loan").get();
  }

  getFarmerLoanRecord() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = await _auth.currentUser;
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: user!.email)
        .get();
  }

  getLoanDetails() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = await _auth.currentUser;
    return await FirebaseFirestore.instance
        .collection("loans")
        .doc(user!.uid)
        .get();
  }

  getUserName() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    User? user = await _auth.currentUser;
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
  }

  getFarmerLoanState() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = await _auth.currentUser;
    return await FirebaseFirestore.instance
        .collection("loans")
        .where("email", isEqualTo: user!.email)
        .get();
  }
}
