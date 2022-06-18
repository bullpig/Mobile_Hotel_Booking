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
    // this.distance = sqrt(
    //     pow((myLocation.latitude! - this.location.latitude), 2) +
    //         pow((myLocation.longitude! - this.location.longitude), 2));
    // double R = 6371;
    // double dLat = (this.location.latitude - myLocation.latitude!) * PI / 180;
    // double dLon = (this.location.longitude - myLocation.longitude!) * PI / 180;
    // double la1ToRad = this.location.latitude * PI / 180;
    // double la2ToRad = myLocation.latitude! * PI / 180;
    // double a = sin(dLat / 2) * sin(dLat / 2) +
    //     cos(la1ToRad) * cos(la2ToRad) * sin(dLon / 2) * sin(dLon / 2);
    // double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    // this.distance = R * c;
    // print(distance);
    double latitude1 = this.location.latitude * 0.01746031;
    double latitude2 = myLocation.latitude! * 0.01746031;
    double longitude1 = this.location.longitude * 0.01746031;
    double longitude2 = myLocation.longitude! * 0.01746031;
    double temp = 6378 *
        acos((sin(latitude1) * sin(latitude2)) +
            cos(latitude1) * cos(latitude2) * cos(longitude2 - longitude1));

    this.distance = double.parse(temp.toStringAsFixed(1));
    print(this.distance);
  }

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
