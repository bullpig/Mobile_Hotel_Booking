import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/homeScreen.dart';
import 'package:hotel_booking/screens/listOrderScreen.dart';
import 'package:hotel_booking/screens/loginScreen.dart';
import 'package:hotel_booking/screens/mainHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 250.0,
                child: Image(
                  image: AssetImage('assets/images/santorini.jpg'),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                bottom: -60,
                child: Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 4.0,
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/user4.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -88,
                child: Text(
                  'Đoàn Duy Cường',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 88.0,
          ),
          Expanded(
            child: ListView(children: [
              ListTile(
                  leading: Icon(
                    Icons.list_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text("Phòng đã đặt"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListOrderScreen(),
                      ),
                    );
                  }),
              ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text("Đăng xuất"),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove("cityId");
                    prefs.remove("cityName");
                    _signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }),
            ]),
          ),
        ],
      ),
    );
  }
}
