// ignore: file_names
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/homeScreen.dart';
import './registerationScreen.dart';
// import '../api_controller.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("assets/images/bookme.png"),
                width: 390.0,
                height: 250.0,
              ),
              SizedBox(height: 1.0),
              Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.black,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      // onPressed: (){
                      //   Navigator.push(context, route)
                      // }
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () async {
                        log("Press login");
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                          if (user != null) {
                            log("Logged in");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),),);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Text(
                  'Không có tài khoản? Đăng ký abc ngay!',
                ),
                onPressed: () {
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, registerationScreen.idScreen, (route) => false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => registerationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
