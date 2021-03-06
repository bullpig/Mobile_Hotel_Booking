import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/screens/listOrderScreen.dart';
import 'package:hotel_booking/screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_booking/screens/resetPassWordScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

String userName = "Đỗ Quang Huynh";
String imageUser =
    "https://vsmcamp.com/wp-content/uploads/2020/11/JaZBMzV14fzRI4vBWG8jymplSUGSGgimkqtJakOV.jpeg";

class _ProfileScreenState extends State<ProfileScreen> {
  void setUp() async {
    var list = await getUserName();
    if (list.length == 2 && this.mounted == true) {
      setState(() {
        userName = list[0];
        imageUser = list[1];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setUp();
  }

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
                      image: NetworkImage(imageUser),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -88,
                child: Text(
                  userName,
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
                    Icons.password_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text("Thay đổi mật khẩu"),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => resetPassWordScreen(),
                      ),
                    );
                  }),
              ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text("Đăng xuất"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                        (route) => false).then((value) {
                      SharedPreferences.getInstance().then((value) {
                        value.remove("cityId");
                        value.remove("cityName");
                      });
                      _signOut();
                    });
                  }),
                  
            ]),
          ),
        ],
      ),
    );
  }
}
