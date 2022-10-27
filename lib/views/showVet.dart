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
   QuerySnapshot? recordsSnapshot;

  
  checkRole(DocumentSnapshot snapshot) {
   
  }

  Widget recordTile() {
    return recordsSnapshot != null
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // padding: EdgeInsets.only(bottom: 10.0),
                  height: 350.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.green, spreadRadius: 3),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/wakulima.png',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),

                          Icon(Icons.person_pin),
                          // Center(
                          //   child: Text(
                          //     '$name',
                          //     // style: mediumTextStyle()
                          //     style: TextStyle(
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),

                          Column(
                            children: [
                              Center(
                                child: Text(
                                    recordsSnapshot!
                                        .docs[index].get('email'),
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Center(
                                  child: Text(
                                      ' ${recordsSnapshot!.docs[index].get('name')} : ${recordsSnapshot!.docs[index].get("phone_number")}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        //fontFamily: 'Nunito-Regular',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Specialization: ${recordsSnapshot!.docs[index].get("specialization")}',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                     // fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Experience: ${recordsSnapshot!.docs[index].get("experience")} years',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                     // fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Charges per service: ${recordsSnapshot!.docs[index].get("Charges")} Kshs',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    //  fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Center(
                                child: Text(
                                    'Working Hours: ${recordsSnapshot!.docs[index].get("working hours")}',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      //fontFamily: 'Nunito-Regular',
                                    )),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        color: Colors.green,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.call),
                                        color: Colors.white,
                                        tooltip: "Call",
                                        onPressed: () {
                                         /*  callnow(
                                              'tel:${recordsSnapshot.documents[index].data["phone_number"]}'); */
                                        },
                                      ),
                                    ),
                                    Text("Call"),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.blue,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.message),
                                      color: Colors.white,
                                      tooltip: "Message",
                                      onPressed: () {
                                        /* avigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    )); */
                                      },
                                    ),
                                  ),
                                  Text("Message")
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.black,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.location_searching),
                                      color: Colors.white,
                                      tooltip: "Location",
                                      onPressed: () {
                                        /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Maps())); */
                                      },
                                    ),
                                  ),
                                  Text("Locate Vet"),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
        : Container();
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
