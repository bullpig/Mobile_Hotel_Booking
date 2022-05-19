import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/homeScreen.dart';
import 'package:hotel_booking/screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      runApp(MyApp(auth: false));
    } else {
      runApp(MyApp(auth: true));
    }
  });

  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool auth;
  MyApp({Key? key, required this.auth}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0E52E1),
        // ignore: deprecated_member_use
        accentColor: const Color(0xFFD8ECF1),
        scaffoldBackgroundColor: const Color(0xFFF3F5F7),
      ),
      // home: HomeScreen(),
      home: auth ? HomeScreen() : LoginScreen(),
    );
  }
}
