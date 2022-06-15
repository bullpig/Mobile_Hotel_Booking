import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/search.dart';
import 'package:hotel_booking/widgets/destination_carsousel.dart';
import 'package:hotel_booking/widgets/hotel_carousel.dart';
import '../models/destination_model.dart';


class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {

  String city = "01";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage('assets/images/bookme.png'),
                    width: 80.0,
                    height: 80.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Search()));
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Text(
                'Bạn muốn tìm gì?',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            DestinationCarousel(
              city: city,
            ),
            SizedBox(
              height: 20.0,
            ),
            HotelCarousel(cityId: city,),
          ],
        ),
      ),
    );
  }
}
