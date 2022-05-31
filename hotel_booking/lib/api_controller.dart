import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking/models/destination_model.dart';
import 'package:hotel_booking/models/room.dart';
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
      id: doc.id.toString(),
      name: docData["name"],
      address: docData["address"],
      districtId: docData["districtId"],
      phone: docData["phone"],
      imageUrl: docData["imageUrl"],
      location: docData["location"],
      services: List<String>.from(docData["services"]),
      description: docData["description"],
      rooms: List<String>.from(docData["rooms"]),
    );
    hotel.rating = await getHotelRating(hotel.id);
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

      final hotels = await db
          .collection("hotels")
          .where("districtId", isEqualTo: dest.id)
          .get();
      dest.totalHotel = hotels.docs.length;
      destinations.add(dest);
    } catch (e) {
      print(e);
    }
  }

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
      id: doc.id.toString(),
      name: docData["name"],
      address: docData["address"],
      districtId: docData["districtId"],
      phone: docData["phone"],
      imageUrl: docData["imageUrl"],
      location: docData["location"],
      services: List<String>.from(docData["services"]),
      description: docData["description"],
      rooms: List<String>.from(docData["rooms"]),
    );
    hotel.rating = await getHotelRating(hotel.id);
    hotels.add(hotel);
  }

  return hotels;
}

Future<bool> createBooking(
    String hotelId,
    String roomId,
    BookingType bookingType,
    DateTime startTime,
    DateTime endTime,
    PaymentType paymentType,
    int totalPayment,
    bool isPaid) async {
  try {
    var order = <String, dynamic>{
      "userId": auth.currentUser.uid.toString(),
      "hotelId": hotelId,
      "roomId": roomId,
      "bookingType": bookingType.name,
      "startTime": startTime,
      "endTime": endTime,
      "paymentType": paymentType.name,
      "totalPayment": totalPayment,
      "paymentStatus": isPaid,
    };
    print(order);
    await db.collection("orders").add(order);
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<List<Hotel>> getSuggestHotels() async {
  List<Hotel> hotels = [];

  var event = await db.collection("hotels").limit(5).get();

  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = Hotel(
      id: doc.id.toString(),
      name: docData["name"],
      address: docData["address"],
      districtId: docData["districtId"],
      phone: docData["phone"],
      imageUrl: docData["imageUrl"],
      location: docData["location"],
      services: List<String>.from(docData["services"]),
      description: docData["description"],
      //rating: docData["rating"],
      rooms: List<String>.from(docData["rooms"]),
    );
    hotel.rating = await getHotelRating(hotel.id);
    hotels.add(hotel);
  }

  return hotels;
}

Future<double> getHotelRating(String hotelId) async {
  var rating = 0.0;

  try {
    var event = await db
        .collection("rating")
        .where("hotelId", isEqualTo: hotelId)
        .where("rating", isGreaterThan: 0)
        .get();

    if (event.docs.isEmpty) {
      return rating;
    }
    int sumRating = 0;
    for (var doc in event.docs) {
      sumRating += int.parse(doc.get("rating").toString());
    }
    var rawRating = sumRating / event.docs.length;
    var roundedString = rawRating.toStringAsFixed(1);
    rating = double.parse(roundedString);
  } catch (e) {
    print(e);
  }

  return rating;
}

Future<int> getUserRating(String hotelId) async {
  int rating = 0;

  try {
    var doc = await db
        .collection("rating")
        .doc(hotelId + auth.currentUser.uid.toString())
        .get();

    if (!doc.exists) {
      return rating;
    }

    rating = doc.get("rating");
  } catch (e) {
    print(e);
  }

  return rating;
}

Future<bool> setUserRating(String hotelId, int rating) async {
  try {
    await db
        .collection("rating")
        .doc(hotelId + auth.currentUser.uid.toString())
        .set({
      "userId": auth.currentUser.uid.toString(),
      "hotelId": hotelId,
      "rating": rating,
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<List<Room>> getRoomsByHotel(String hotelId) async {
  List<Room> rooms = [];

  try {
    var event = await db.collection("rooms").get();

    for (var doc in event.docs) {
      var docData = doc.data();
      var room = Room(
        id: doc.id.toString(),
        name: docData["name"],
        hotelId: docData["hotelId"],
        imageUrl: docData["imageUrl"],
        description: List<String>.from(docData["description"]),
        priceTwoHours: docData["priceTwoHours"],
        priceOvernight: docData["priceOvernight"],
        priceAllday: docData["priceAllday"],
      );
      rooms.add(room);
    }
  } catch (e) {
    print(e);
  }

  return rooms;
}
