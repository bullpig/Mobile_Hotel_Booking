import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/screens/homeScreen.dart';
import 'package:hotel_booking/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking/screens/profileScreen.dart';

// import '../api_controller.dart';

class resetPassWordScreen extends StatelessWidget {
  static const String idScreen = 'register';
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassWord = TextEditingController();

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
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 30.0,
                    color: Colors.blue,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 100),
              Text(
                'Thay đổi mật khẩu',
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
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu hiện tại',
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
                    TextField(
                      controller: newPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
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
                    TextField(
                      controller: confirmPassWord,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Nhập lại mật khẩu',
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
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () async {
                        if (password.text.isEmpty == true ||
                            newPassword.text.isEmpty == true ||
                            confirmPassWord.text.isEmpty == true) {
                          Fluttertoast.showToast(
                              msg: 'Yêu cầu nhập đầy đủ thông tin');
                        } else if (newPassword.text != confirmPassWord.text) {
                          Fluttertoast.showToast(
                              msg: 'Mật khẩu mới không khớp');
                        } else {
                          var result = await changePassword(
                              password.text, newPassword.text);
                          if (result == "OK") {
                            Fluttertoast.showToast(
                                msg: 'Thay đổi mật khẩu thành công');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => HomeScreen.withScreen(4)),
                            );
                          } else if (result == "WrongPassWord") {
                            Fluttertoast.showToast(
                                msg: 'Mật khẩu không chính xác');
                          } else if (result == "False") {
                            Fluttertoast.showToast(msg: 'False');
                          } else if (result == "No") {
                            Fluttertoast.showToast(msg: 'No');
                          } else if (result == "Falsess") {
                            Fluttertoast.showToast(msg: 'Falsess');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
