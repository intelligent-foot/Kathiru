import 'package:flutter/material.dart';
import 'package:mukurewini/views/chat.dart';
import 'package:mukurewini/views/home.dart';
import 'package:mukurewini/views/profile_screen.dart';

class Users extends StatefulWidget {
  const Users({super.key});

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
      child: Scaffold(appBar: AppBar(title: Text('Farmers'),
      bottom: TabBar(tabs: [
        Tab(icon: Icon(Icons.people_outline),
        text: 'farmers',
        ),
        Tab(icon: Icon(Icons.search),
        text: 'search',
        ),
      ],
      ),
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

      body: TabBarView(children: [
        Farmer(),SearchFarmer()
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




class SearchFarmer extends StatefulWidget {
  const SearchFarmer({super.key});

  @override
  State<SearchFarmer> createState() => _SearchFarmerState();
}

class _SearchFarmerState extends State<SearchFarmer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}