import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

// reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  CollectionReference vet = FirebaseFirestore.instance.collection('vet');
  CollectionReference milk = FirebaseFirestore.instance.collection('milk');
  //saving the userdata
  Future savingUserData(String fullName, String email, /*String Kilograms,String ServedBy*/) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
      "role": 'user',
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

  Future uploadMilkInfo(
      String userId, String name, String date, int kilograms) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User user = await _auth.currentUser!;

    return await milk.doc(userId).set({
      'id': userId,
      'email': user.email,
      'date': date,
      'kilograms': kilograms
    }).catchError((e) {
      print(e.toString());
    });
  }

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
}
