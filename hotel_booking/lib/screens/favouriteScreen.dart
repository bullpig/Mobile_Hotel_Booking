import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
// import 'package:hotel_app/screens/hotelDetails.dart';
// import 'package:hotel_app/screens/success.dart';
// import 'package:hotel_app/widgets/overNightpicker.dart';
// import 'package:hotel_app/widgets/twoHourspicker.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({Key? key}) : super(key: key);
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<ShortenHotel> favoriteHotel = tempHotel;

  @override
  void initState() {
    super.initState();
    getFavoriteHotel().then((value) => setState(() => favoriteHotel = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách yêu thích',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Image.asset('assets/images/bookme.png'),
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: favoriteHotel.length,
        itemBuilder: (BuildContext context, int index) {
          ShortenHotel hotel = favoriteHotel[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelDetail(hotelId: hotel.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: (hotel.imageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(hotel.imageUrl)
                                : const AssetImage("assets/images/loading.gif"))
                            as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5.0,
                    bottom: 5.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelDetail(hotelId: hotel.id),
                          ),
                        );
                      },
                      child: Text('Xem ngay'),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: Text(
                      hotel.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
