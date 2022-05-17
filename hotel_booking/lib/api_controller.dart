import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking/models/destination_model.dart';

import './models/hotel_model.dart';

final db = FirebaseFirestore.instance;

Future<List<Hotel>> getHotelsByDestination(String destination) async {
  List<Hotel> hotels = [];

  var event =
      await db.collection("hotels").where("city", isEqualTo: destination).get();
  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = Hotel(
      imageUrl: docData["image"],
      name: docData["name"],
      address: docData["address"],
      twohourprice: docData["price2hours"].toDouble(),
      overnightprice: docData["price"].toDouble(),
      rating: docData["rating"],
      introduction: docData["description"],
      services: List<String>.from(docData["services"] ?? []),
    );
    print("${hotel.name} -> ${hotel.services.toString()}");
    hotels.add(hotel);
  }

  return hotels;
}

Future<List<Destination>> getDestination() async {
  List<Destination> destinations = [];

  var event = await db.collection("cities").get();
  for (var doc in event.docs) {
    var dest = Destination(
        imageUrl: doc.get("imageUrl"),
        city: doc.get("city"),
        country: doc.get("country"),
        description: doc.get("description"));

    dest.hotels = await getHotelsByDestination(dest.city);
    destinations.add(dest);
  }

  return destinations;
}
