import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'dart:core';

const PI = 3.1415;

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
  double distance;

  Hotel(
      {this.id = "",
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
      this.distance = 0.0});

  void setDistance(LocationData myLocation) {
    double latitude1 = this.location.latitude * 0.01746031;
    double latitude2 = myLocation.latitude! * 0.01746031;
    double longitude1 = this.location.longitude * 0.01746031;
    double longitude2 = myLocation.longitude! * 0.01746031;
    double temp = 6378 *
        acos((sin(latitude1) * sin(latitude2)) +
            cos(latitude1) * cos(latitude2) * cos(longitude2 - longitude1));

    this.distance = double.parse(temp.toStringAsFixed(1));

  }

  String toString() {
    return this.id +
        "  " +
        this.name +
        "  " +
        this.location.latitude.toString();
  }
}

class ShortenHotel {
  String id;
  String name;
  String address;
  String imageUrl;
  double rating;
  List<String> rooms;
  GeoPoint location;

  ShortenHotel({
    this.id = "",
    this.name = "",
    this.address = "",
    this.imageUrl = "",
    this.rating = 0.0,
    this.rooms = const [],
    this.location = const GeoPoint(0, 0)
  });
}

var tempHotel = [ShortenHotel(), ShortenHotel()];
