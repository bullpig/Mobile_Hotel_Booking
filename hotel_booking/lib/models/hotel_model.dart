import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

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
    this.distance = sqrt(
        pow((myLocation.latitude! - this.location.latitude), 2) +
            pow((myLocation.longitude! - this.location.longitude), 2));
  }

  // int compareTo(Hotel hotelDiff, LocationData myLocation) {
  //   double distanceThis = sqrt(
  //       pow((myLocation.latitude! - this.location.latitude), 2) +
  //           pow((myLocation.longitude! - this.location.longitude), 2));
  //   double distanceArgument = sqrt(
  //       pow((myLocation.latitude! - hotelDiff.location.latitude), 2) +
  //           pow((myLocation.longitude! - hotelDiff.location.longitude), 2));
  //   return distanceThis > distanceArgument ? 1 : -1;
  // }

  String toString() {
    return this.id + this.name;
  }
}

class ShortenHotel {
  String id;
  String name;
  String address;
  String imageUrl;
  double rating;
  List<String> rooms;

  ShortenHotel({
    this.id = "",
    this.name = "",
    this.address = "",
    this.imageUrl = "",
    this.rating = 0.0,
    this.rooms = const [],
  });
}

var tempHotel = [ShortenHotel(), ShortenHotel()];
