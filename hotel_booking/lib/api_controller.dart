import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import './models/hotel_model.dart';

final db = FirebaseFirestore.instance;

Future<List<Hotel>> getHotelsByDestination(String destination) async {
  List<Hotel> hotels = [];

  var event = await db
      .collection("hotels")
      .where("district", isEqualTo: destination)
      .get();
  for (var doc in event.docs) {
    var hotel = Hotel(
      imageUrl: doc.get("image"),
      name: doc.get("name"),
      address: doc.get("address"),
      twohourprice: doc.get("price2hours").toDouble(),
      overnightprice: doc.get("price").toDouble(),
      rating: doc.get("rating"),
      introduction: doc.get("description"),
    );
    hotels.add(hotel);
  }
  log("${destination} => ${hotels.length}");

  if (hotels.isEmpty) return temp_hotels;

  return hotels;
}
