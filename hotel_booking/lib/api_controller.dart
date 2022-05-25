import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking/models/destination_model.dart';
import 'package:hotel_booking/utils/utils.dart';

import './models/hotel_model.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

Future<bool> addUserInfo(
    String uid, String email, String phone, String name) async {
  try {
    var user = <String, dynamic>{"email": email, "name": name, "phone": phone};
    await db.collection("users").doc(uid).set(user);
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<List<Hotel>> getHotelsByDestination(String destinationId) async {
  List<Hotel> hotels = [];

  var event = await db
      .collection("hotels")
      .where("districtId", isEqualTo: destinationId)
      .get();
  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = Hotel(
      id: doc.id,
      imageUrl: docData["image"],
      name: docData["name"],
      address: docData["address"],
      twohourprice: docData["price2hours"].toDouble(),
      overnightprice: docData["price"].toDouble(),
      rating: docData["rating"],
      introduction: docData["description"] ?? "",
      services: List<String>.from(docData["services"] ?? []),
    );
    hotels.add(hotel);
  }

  return hotels;
}

Future<List<Destination>> getDestination(String city) async {
  List<Destination> destinations = [];

  var event =
      await db.collection("districts").where("cityId", isEqualTo: city).get();
  for (var doc in event.docs) {
    try {
      var dest = Destination(
          id: doc.id,
          imageUrl: doc.get("imageUrl"),
          name: doc.get("name"),
          city: doc.get("cityName"),
          description: "");

      dest.hotels = await getHotelsByDestination(dest.id);
      destinations.add(dest);
    } catch (e) {
      print(e);
    }
  }

  print(destinations);

  return destinations;
}

Future<void> setHotelFavoriteStatus(String hotelId, bool isFavorite) async {
  if (isFavorite) {
    final userRef = db.collection("users").doc(auth.currentUser.uid);
    await userRef.update({
      "favoriteHotel": FieldValue.arrayUnion([hotelId])
    });
  } else {
    final userRef = db.collection("users").doc(auth.currentUser.uid);
    await userRef.update({
      "favoriteHotel": FieldValue.arrayRemove([hotelId])
    });
  }
}

Future<List<String>> getFavoriteHotelIds() async {
  var doc = await db.collection("users").doc(auth.currentUser.uid).get();
  var hotelIds = List<String>.from(doc.get("favoriteHotel") ?? []);

  return hotelIds;
}

Future<bool> getHotelFavoriteStatus(String hotelId) async {
  var listHotel = await getFavoriteHotelIds();
  if (listHotel.contains(hotelId)) {
    return true;
  }
  return false;
}

Future<List<Hotel>> getFavoriteHotel() async {
  List<Hotel> hotels = [];

  var hotelIds = await getFavoriteHotelIds();

  if (hotelIds.isEmpty) {
    return hotels;
  }

  var event = await db
      .collection("hotels")
      .where(FieldPath.documentId, whereIn: hotelIds)
      .get();

  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = Hotel(
      id: doc.id,
      imageUrl: docData["image"],
      name: docData["name"],
      address: docData["address"],
      twohourprice: docData["price2hours"].toDouble(),
      overnightprice: docData["price"].toDouble(),
      rating: docData["rating"],
      introduction: docData["description"] ?? "",
      services: List<String>.from(docData["services"] ?? []),
    );
    hotels.add(hotel);
  }

  return hotels;
}

Future<bool> createBooking(
    String hotelId,
    BookType bookingType,
    DateTime startTime,
    DateTime endTime,
    PaymentType paymentType,
    bool isPaid) async {
  try {
    var order = <String, dynamic>{
      "uid": auth.currentUser.uid.toString(),
      "hotelId": hotelId,
      "bookingType": bookingType.name,
      "startTime": startTime,
      "endTime": endTime,
      "paymentType": paymentType.name,
      "isPaid": isPaid,
    };
    await db.collection("orders").add(order);
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<List<Hotel>> getSuggestHotels() async {
  List<Hotel> hotels = [];

  var event = await db
      .collection("hotels")
      .limit(5)
      .get();

  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = Hotel(
      id: doc.id,
      imageUrl: docData["image"],
      name: docData["name"],
      address: docData["address"],
      twohourprice: docData["price2hours"].toDouble(),
      overnightprice: docData["price"].toDouble(),
      rating: docData["rating"],
      introduction: docData["description"] ?? "",
      services: List<String>.from(docData["services"] ?? []),
    );
    hotels.add(hotel);
  }

  return hotels;
}


