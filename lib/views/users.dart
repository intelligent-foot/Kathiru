import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mukurewini/read%20data/get_user_name.dart';
import 'package:mukurewini/service/auth_service.dart';
import 'package:mukurewini/service/database_service.dart';
import 'package:mukurewini/views/MilkRecords.dart';
import 'package:mukurewini/views/chat.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/views/milk.dart';
import 'package:mukurewini/views/profile_screen.dart';
import 'package:mukurewini/widgets/widgets.dart';

class Users extends StatefulWidget {
  
  const Users({super.key,});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Farmers'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.people_outline),
                text: 'farmers',
              ),
              Tab(
                icon: Icon(Icons.search),
                text: 'search',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [Farmer(), SearchFarmer()],
        ),
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
      ),
    );
  }
}

class Farmer extends StatefulWidget {
  
   const Farmer({super.key});

  @override
  State<Farmer> createState() => _FarmerState();
}

class _FarmerState extends State<Farmer> {
  final formKey = GlobalKey<FormState>();
  TextEditingController todayMilkController = new TextEditingController();
  TextEditingController previousMilkController = new TextEditingController();
  TextEditingController cumulativeMilkController = new TextEditingController();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  QuerySnapshot? recordsSnapshot;
  User? username;
  String name = 'joseph';
  String? email;
  double total = 0.0;
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  /* Widget recordList() {
    
    return 
        ? ListView.builder(
            itemCount: recordsSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return recordTile(
                  email: recordsSnapshot!.docs[index].data()['email'],
                  name: recordsSnapshot!.docs[index].data()["name"],
                  farmerId: recordsSnapshot!.docs[index].data()["farmerId"]);
            })
        : Container();
  } */

  Widget recordTile(
      {required String email, required String name, required int farmerId}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.green, spreadRadius: 3),
            ],
          ),
          width: 50,
          height: 70,
          child: Card(
            child: Center(
              child: Text(
                'Name: $name\nID: $farmerId\nEmail: $email',
                // style: mediumTextStyle(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
      future: getDocId(),
      builder: ((context, snapshot) {
        return ListView.builder(
          itemCount: docIDs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  
                },
                tileColor: Colors.blueGrey,
                title: GetUserName(documentId: docIDs[index]),
              ),
            );
          },
        );
      }),
    ));
  }
}

class SearchFarmer extends StatefulWidget {
  const SearchFarmer({super.key});

  @override
  State<SearchFarmer> createState() => _SearchFarmerState();
}

class _SearchFarmerState extends State<SearchFarmer> {
  DatabaseService databaseService = DatabaseService();
  TextEditingController searchTextEditingController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  QuerySnapshot? recordsSnapshot;

  /*  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot!.docs[index].data('fullName'),
                  farmerId: searchSnapshot!.docs[index].data('uid'),
                  email: searchSnapshot!.docs[index].data('email'));
            },
          )
        : Container();
  } */

  initiateSearch() {
    databaseService
        .getFarmerId(int.parse(searchTextEditingController.text))
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    print('search results is ${searchTextEditingController.text}');
  }

  Widget SearchTile({String? userName, int? farmerId, String? email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName!,
                style: mediumTextStyle(),
              ),
              Text(
                'farmerId: $farmerId',
                style: mediumTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                'Dairy',
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: searchTextEditingController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'search farmer...',
                      hintStyle: TextStyle(color: Colors.greenAccent),
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(12),
                      child: Image.asset('assets/images/search_white.png')),
                )
              ],
            ),
          ),
          //  searchList()
        ],
      ),
    );
  }
}
