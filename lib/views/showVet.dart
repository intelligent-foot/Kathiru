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

  Widget recordTile() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('vet').snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Container()
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 350.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                    const Icon(Icons.person_pin),
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(data['email'],
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 12.0,
                                        ),
                                        Center(
                                          child: Center(
                                            child: Text('${data['name']}',
                                                style: const TextStyle(
                                                  fontSize: 17.0,
                                                  //fontFamily: 'Nunito-Regular',
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12.0,
                                        ),
                                        Center(
                                          child: Text(
                                              'Specialization: ${data["specialization"]}',
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                // fontFamily: 'Nunito-Regular',
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 12.0,
                                        ),
                                        Center(
                                          child: Text(
                                              'Experience: ${data["experience"]} years',
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                // fontFamily: 'Nunito-Regular',
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 12.0,
                                        ),
                                        Center(
                                          child: Text(
                                              'Charges per service: ${data["Charges"]} Kshs',
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                //  fontFamily: 'Nunito-Regular',
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 12.0,
                                        ),
                                        Center(
                                          child: Text(
                                              'Working Hours: ${data["working hours"]}',
                                              style: const TextStyle(
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
                                                decoration:
                                                    const ShapeDecoration(
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
                                              const Text("Call"),
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
                                            const Text("Message")
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
                                                icon: Icon(
                                                    Icons.location_searching),
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
                                            const Text("Locate Vet"),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }));
          })),
    );
  }

  checkRole(DocumentSnapshot snapshot) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Veterinary'),
            ),
            StreamBuilder<Object>(
                stream:
                    FirebaseFirestore.instance.collection('vet').snapshots(),
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
      ), */
      appBar: AppBar(
        title: const Text('Available Veterinaries'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 50,
          // alignment: Alignment.topCenter,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("vet").snapshots(),
              builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        recordTile(),
                      ]),
                );
              }),
        ),
      ),
    );
  }
}
