import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking/models/destination_model.dart';
import 'package:hotel_booking/models/location_hotel.dart';
import 'package:hotel_booking/models/order.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/models/voucher.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:location/location.dart';

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

Future<List<ShortenHotel>> getHotelsByDestination(String destinationId) async {
  List<ShortenHotel> hotels = [];

  var event = await db
      .collection("hotels")
      .where("districtId", isEqualTo: destinationId)
      .get();
  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = ShortenHotel(
      id: doc.id.toString(),
      name: docData["name"],
      address: docData["address"],
      imageUrl: docData["imageUrl"],
      location: docData["location"],
      rooms: List<String>.from(
        docData["rooms"],
      ),
    );
    if (hotel.rooms.length > 3) {
      hotel.rooms = hotel.rooms.sublist(0, 3);
      hotel.rooms.add("...");
    }
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
      log(e.toString());
    }
  }

  return destinations;
}

Future<void> setHotelFavoriteStatus(String hotelId, bool isFavorite) async {
  if (isFavorite) {
    final userRef = db.collection("users").doc(auth.currentUser?.uid);
    await userRef.update({
      "favoriteHotel": FieldValue.arrayUnion([hotelId])
    });
  } else {
    final userRef = db.collection("users").doc(auth.currentUser?.uid);
    await userRef.update({
      "favoriteHotel": FieldValue.arrayRemove([hotelId])
    });
  }
}

Future<List<String>> getFavoriteHotelIds() async {
  var doc = await db.collection("users").doc(auth.currentUser?.uid).get();
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

Future<List<ShortenHotel>> getFavoriteHotel() async {
  List<ShortenHotel> hotels = [];

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
    var hotel = ShortenHotel(
      id: doc.id.toString(),
      name: docData["name"],
      address: docData["address"],
      imageUrl: docData["imageUrl"],
      rooms: List<String>.from(docData["rooms"]),
    );
    hotels.add(hotel);
  }

  return hotels;
}

Future<String> createBooking(
    String hotelId,
    String roomId,
    BookingType bookingType,
    DateTime startTime,
    DateTime endTime,
    PaymentType paymentType,
    int totalPayment,
    bool isPaid,
    String? voucherId,
    int? totalDiscount) async {
  try {
    var order = <String, dynamic>{
      "userId": auth.currentUser?.uid.toString(),
      "hotelId": hotelId,
      "roomId": roomId,
      "bookingType": bookingType.name,
      "startTime": startTime,
      "endTime": endTime,
      "paymentType": paymentType.name,
      "totalPayment": totalPayment,
      "paymentStatus": isPaid,
      "bookingTime": FieldValue.serverTimestamp(),
    };
    if (voucherId != null && totalDiscount != 0) {
      order["voucherId"] = voucherId;
      order["totalDiscount"] = totalDiscount;
    }
    var orderDoc = await db.collection("orders").add(order);
    return orderDoc.id;
  } catch (e) {
    log(e.toString());
    return "";
  }
}

Future<List<ShortenHotel>> getSuggestHotels(String cityId) async {
  List<ShortenHotel> hotels = [];

  try {
    var destQuery = await db
        .collection("districts")
        .where("cityId", isEqualTo: cityId)
        .get();

    for (var dest in destQuery.docs) {
      String destId = dest.id;
      var hotelQuery = await db
          .collection("hotels")
          .where("districtId", isEqualTo: destId)
          .get();
      List<ShortenHotel> destHotels = [];
      for (var doc in hotelQuery.docs) {
        var docData = doc.data();
        var hotel = ShortenHotel(
          id: doc.id.toString(),
          name: docData["name"],
          address: docData["address"],
          imageUrl: docData["imageUrl"],
        );
        hotel.rating = await getHotelRating(hotel.id);
        destHotels.add(hotel);
      }
      if (destHotels.isNotEmpty) {
        destHotels.sort(((a, b) => a.rating.compareTo(b.rating)));
        hotels.add(destHotels.last);
      }
    }
  } catch (e) {
    log(e.toString());
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
    log(e.toString());
  }

  return rating;
}

Future<int> getUserRating(String hotelId) async {
  int rating = 0;

  try {
    var uid = auth.currentUser?.uid.toString();
    if (uid != null) {
      var doc = await db.collection("rating").doc(hotelId + uid).get();
      if (!doc.exists) {
        return rating;
      }

      rating = doc.get("rating");
    }
  } catch (e) {
    log(e.toString());
  }

  return rating;
}

Future<bool> setUserRating(String hotelId, int rating) async {
  try {
    var uid = auth.currentUser?.uid.toString();
    if (uid != null) {
      await db.collection("rating").doc(hotelId + uid).set({
        "userId": auth.currentUser?.uid.toString(),
        "hotelId": hotelId,
        "rating": rating,
      });
      return true;
    }
    return false;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<List<Room>> getRoomsByHotel(String hotelId) async {
  List<Room> rooms = [];

  try {
    var event =
        await db.collection("rooms").where("hotelId", isEqualTo: hotelId).get();

    for (var doc in event.docs) {
      var docData = doc.data();
      try {
        var room = Room(
          id: doc.id.toString(),
          name: docData["name"],
          hotelId: docData["hotelId"],
          imageUrl: docData["imageUrl"],
          description: List<String>.from(docData["description"] ?? []),
          priceTwoHours: docData["priceTwoHours"],
          priceOvernight: docData["priceOvernight"],
          priceAllday: docData["priceAllday"],
        );
        rooms.add(room);
      } catch (err) {
        log(err.toString());
      }
    }
  } catch (e) {
    log(e.toString());
  }

  return rooms;
}

Future<List<Room>> getAvailableRooms(
    String hotelId, DateTime startDate, DateTime endDate) async {
  List<Room> rooms = [];

  List<String> unavailableRoomIds = [];

  try {
    var ordersQuery = await db
        .collection("orders")
        .where("hotelId", isEqualTo: hotelId)
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .get();

    for (var doc in ordersQuery.docs) {
      var docData = doc.data();
      DateTime orderStartDate = docData["startTime"].toDate();
      DateTime orderEndDate = docData["endTime"].toDate();
      if (!(orderEndDate.isBefore(startDate) ||
              orderEndDate.isAtSameMomentAs(startDate)) &&
          !(orderStartDate.isAfter(endDate) ||
              orderStartDate.isAtSameMomentAs(endDate))) {
        unavailableRoomIds.add(docData["roomId"]);
      }
    }
  } catch (e) {
    log(e.toString());
  }

  try {
    var event;

    if (unavailableRoomIds.isNotEmpty) {
      event = await db
          .collection("rooms")
          .where("hotelId", isEqualTo: hotelId)
          .where(FieldPath.documentId, whereNotIn: unavailableRoomIds)
          .get();
    } else {
      event = await db
          .collection("rooms")
          .where("hotelId", isEqualTo: hotelId)
          .get();
    }

    for (var doc in event.docs) {
      var docData = doc.data();

      var room = Room(
        id: doc.id.toString(),
        name: docData["name"],
        hotelId: docData["hotelId"],
        imageUrl: docData["imageUrl"],
        description: List<String>.from(docData["description"] ?? []),
        priceTwoHours: docData["priceTwoHours"],
        priceOvernight: docData["priceOvernight"],
        priceAllday: docData["priceAllday"],
      );
      rooms.add(room);
    }
  } catch (e) {
    log(e.toString());
  }

  return rooms;
}

Future<List<Hotel>> getHotelSortByLocation(LocationData myLocation) async {
  List<Hotel> hotels = [];

  try {
    var event = await db.collection("hotels").get();
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
      hotel.setDistance(myLocation);
      hotels.add(hotel);
      print(hotel.toString());
    }
    hotels.sort(((a, b) => a.distance.compareTo(b.distance)));
    for (var i in hotels) {
      print(i.distance);
    }
  } catch (e) {
    print(e);
  }

  return hotels;
}

// Future<List<ShortenHotel>> getShortenHotelSortByLocation(LocationData myLocation) async {
//   List<ShortenHotel> hotels = [];

//   try {
//     var event = await db.collection("hotels").get();
//     for (var doc in event.docs) {
//       var docData = doc.data();
//       var hotel = ShortenHotel(
//         id: doc.id.toString(),
//         name: docData["name"],
//         address: docData["address"],
//         imageUrl: docData["imageUrl"],
//         location: docData["location"],
//         rooms: List<String>.from(docData["rooms"]),
//       );
//       hotel.rating = await getHotelRating(hotel.id);
//       hotels.add(hotel);
//       print(hotel.toString());
//     }
//     hotels.sort(((a, b) => a.distance.compareTo(b.distance)));
//     for (var i in hotels) {
//       print(i.distance);
//     }
//   } catch (e) {
//     print(e);
//   }

//   return hotels;
// }

Future<List<Order>> getOrders() async {
  List<Order> orders = [];

  try {
    var event = await db
        .collection("orders")
        .where("userId", isEqualTo: auth.currentUser?.uid.toString())
        .orderBy("bookingTime", descending: true)
        .get();

    for (var doc in event.docs) {
      var docData = doc.data();
      var order = Order(
        id: doc.id,
        hotelId: docData["hotelId"],
        roomId: docData["roomId"],
        bookingType: BookingType.values.byName(docData["bookingType"]),
        startTime: docData["startTime"].toDate(),
        endTime: docData["endTime"].toDate(),
        paymentType: PaymentType.values.byName(docData["paymentType"]),
        totalPayment: docData["totalPayment"],
        paymentStaus: docData["paymentStatus"],
        voucherId: docData["voucherId"],
        totalDiscount: docData["totalDiscount"],
      );
      var room = await db.collection("rooms").doc(order.roomId).get();
      order.roomName = room.get("name");
      order.roomImageUrl = room.get("imageUrl");
      var hotel = await db.collection("hotels").doc(order.hotelId).get();
      order.hotelName = hotel.get("name");
      orders.add(order);
    }
  } catch (e) {
    log(e.toString());
  }

  return orders;
}

Future<Hotel> getHotelById(String hotelId) async {
  Hotel hotel = Hotel();
  hotel.id = hotelId;

  try {
    var doc = await db.collection("hotels").doc(hotelId).get();
    hotel.name = doc.get("name");
    hotel.address = doc.get("address");
    hotel.districtId = doc.get("districtId");
    hotel.phone = doc.get("phone");
    hotel.imageUrl = doc.get("imageUrl");
    hotel.location = doc.get("location");
    hotel.services = List<String>.from(doc.get("services"));
    hotel.description = doc.get("description");
    hotel.rooms = List<String>.from(doc.get("rooms"));
    hotel.rating = await getHotelRating(hotel.id);
  } catch (e) {
    log(e.toString());
  }

  return hotel;
}

Future<bool> updatePaymentStatus(String orderId, bool paymentStatus) async {
  try {
    final userRef = db.collection("orders").doc(orderId);
    await userRef.update({
      "paymentStatus": paymentStatus,
    });
    return true;
  } catch (e) {
    log(e.toString());
  }

  return false;
}

Future<List<Map<String, String>>> getVouchers() async {
  List<Map<String, String>> returnedVouchers = [];

  try {
    var query = await db
        .collection("vouchers")
        .where("endTime", isGreaterThanOrEqualTo: DateTime.now())
        .get();
    for (var doc in query.docs) {
      var docData = doc.data();

      if (DateTime.now().isBefore(docData["startTime"].toDate())) {
        continue;
      }
      Map<String, String> voucher = {
        "id": doc.id,
        "imageUrl": docData["imageUrl"] ?? defaultImageUrl,
      };
      returnedVouchers.add(voucher);
    }
  } catch (e) {
    print(e.toString());
  }

  return returnedVouchers;
}

Future<Voucher> getVoucher(String voucherId) async {
  try {
    var doc = await db.collection("vouchers").doc(voucherId).get();
    var docData = doc.data()!;

    var voucher = Voucher(
      id: doc.id,
      name: docData["name"] ?? "",
      description: docData["description"] ?? "",
      imageUrl: docData["imageUrl"] ?? defaultImageUrl,
      startTime: docData["startTime"].toDate(),
      endTime: docData["endTime"].toDate(),
      type: VoucherType.values.byName(docData["type"]),
      discountValue: docData["discountValue"],
      maxDiscount: docData["maxDiscount"],
      isForAll:
          docData["appliedHotels"].isEmpty && docData["appliedRooms"].isEmpty
              ? true
              : false,
    );
    return voucher;
  } catch (e) {
    print(e.toString());
  }

  return Voucher();
}

Future<List<ShortenHotel>> getDiscountedHotels(String voucherId) async {
  List<ShortenHotel> hotels = [];

  var voucher = await db.collection("vouchers").doc(voucherId).get();
  List<String> hotelIds = List<String>.from(voucher.get("appliedHotels") ?? []);

  if (hotelIds.isEmpty) {
    return hotels;
  }

  var event = await db
      .collection("hotels")
      .where(FieldPath.documentId, whereIn: hotelIds)
      .get();
  for (var doc in event.docs) {
    var docData = doc.data();
    var hotel = ShortenHotel(
      id: doc.id.toString(),
      name: docData["name"],
      address: docData["address"],
      imageUrl: docData["imageUrl"],
      rooms: List<String>.from(docData["rooms"]),
    );
    if (hotel.rooms.length > 3) {
      hotel.rooms = hotel.rooms.sublist(0, 3);
      hotel.rooms.add("...");
    }
    hotel.rating = await getHotelRating(hotel.id);
    hotels.add(hotel);
  }

  return hotels;
}

Future<List<Voucher>> getVouchersByHotel(String hotelId) async {
  List<Voucher> resVouchers = [];

  try {
    var query = await db
        .collection("vouchers")
        .where("endTime", isGreaterThanOrEqualTo: DateTime.now())
        .get();

    for (var doc in query.docs) {
      var docData = doc.data();

      if (DateTime.now().isBefore(docData["startTime"].toDate())) {
        continue;
      }

      if (docData["appliedHotels"].isNotEmpty &&
          !docData["appliedHotels"].contains(hotelId)) {
        continue;
      }

      var voucher = Voucher(
        id: doc.id,
        name: docData["name"] ?? "",
        description: docData["description"] ?? "",
        imageUrl: docData["imageUrl"] ?? defaultImageUrl,
        startTime: docData["startTime"].toDate(),
        endTime: docData["endTime"].toDate(),
        type: VoucherType.values.byName(docData["type"]),
        discountValue: docData["discountValue"],
        maxDiscount: docData["maxDiscount"],
        isForAll:
            docData["appliedHotels"].isEmpty && docData["appliedRooms"].isEmpty
                ? true
                : false,
        appliedRooms: List<String>.from(docData["appliedRooms"] ?? []),
      );
      resVouchers.add(voucher);
    }
  } catch (e) {
    print(e.toString());
  }
  return resVouchers;
}
