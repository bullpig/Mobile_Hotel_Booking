import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/voucher.dart';
import 'package:hotel_booking/widgets/listHotels.dart';
import 'package:hotel_booking/models/hotel_model.dart';

class DiscountedHotelsScreen extends StatefulWidget {
  Voucher voucher;

  DiscountedHotelsScreen({Key? key, required this.voucher}) : super(key: key);

  @override
  DiscountedHotelsState createState() => DiscountedHotelsState();
}

class DiscountedHotelsState extends State<DiscountedHotelsScreen> {
  late Future<List<ShortenHotel>> futureHotels;

  @override
  void initState() {
    super.initState();
    futureHotels = getDiscountedHotels(widget.voucher.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.voucher.name,
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
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: FutureBuilder<List<ShortenHotel>>(
            future: futureHotels,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListHotels(listHotel: snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return ListHotels(listHotel: tempHotel);
            },
          ),
        )));
  }
}
