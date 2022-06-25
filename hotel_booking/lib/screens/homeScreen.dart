import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/eventsScreen.dart';
import 'package:hotel_booking/screens/favouriteScreen.dart';
import 'package:hotel_booking/screens/mainHomeScreen.dart';
import 'package:hotel_booking/screens/profileScreen.dart';
import 'nearScreen.dart';

class HomeScreen extends StatefulWidget {
  int currentTab = 0;

  static String idScreen = 'home';

  HomeScreen() {}
  HomeScreen.withScreen(int tab) {
    currentTab = tab;
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var bottomTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  final Tabs = [
    MainHomeScreen(),
    NearScreen(),
    FavouriteScreen(),
    EventScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tabs[widget.currentTab],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFFB7B7B7),
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: widget.currentTab,
        onTap: (int value) {
          setState(() {
            widget.currentTab = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.room,
              size: 30.0,
            ),
            
            label: "Gần đây",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
              size: 40.0,
            ),
            
            label: "Yêu thích",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.takeout_dining,
              size: 30.0,
            ),
           
            label: "Khuyến mãi",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30.0,
            ),
            
            label: "Cá nhân",
          ),
        ],
        backgroundColor: Colors.transparent,
        showSelectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
