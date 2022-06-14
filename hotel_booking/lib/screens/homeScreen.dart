import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/screens/eventsScreen.dart';
import 'package:hotel_booking/screens/favouriteScreen.dart';
import 'package:hotel_booking/screens/mainHomeScreen.dart';
import 'package:hotel_booking/screens/nearbyScreen.dart';
import 'package:hotel_booking/screens/profileScreen.dart';

import 'nearScreen.dart';
// import 'package:hotel_app/screens/favouriteScreen.dart';
// import 'package:hotel_app/screens/mainHomeScreen.dart';
// import 'package:hotel_app/screens/nearbyScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var bottomTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  int _currentTab = 0;

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
      body: Tabs[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFFB7B7B7),
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentTab,
        onTap: (int value) {
          setState(() {
            _currentTab = value;
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
            // label: (
            //   'Gần đây',
            //   style: bottomTextStyle,
            // ),
            label: "Gần đây",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
              size: 40.0,
            ),
            // label: (
            //   'Yêu thích',
            //   style: bottomTextStyle,
            // ),
            label: "Yêu thích",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.takeout_dining,
              size: 30.0,
            ),
            // label: (
            //   'Khuyến mãi',
            //   style: bottomTextStyle,
            // ),
            label: "Khuyến mãi",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30.0,
            ),
            // label:(
            //   'Cá nhân',
            //   style: bottomTextStyle,
            // ),
            label: "Cá nhân",
          ),
        ],
        backgroundColor: Colors.transparent,
        // type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
