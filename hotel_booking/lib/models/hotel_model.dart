import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  String id;
  String name;
  String address;
  String districtId;
  String phone;
  String imageUrl;
  GeoPoint location;
  List<String> services;
  String description;
  double rating;
  List<String> rooms;

  Hotel({
    this.id = "",
    this.name = "",
    this.address = "",
    this.districtId = "",
    this.phone = "",
    this.imageUrl = "",
    this.location = const GeoPoint(0, 0),
    this.services = const [],
    this.description = "",
    this.rating = 0.0,
    this.rooms = const [],
  });
}

List<Hotel> temp_favorite = [];
