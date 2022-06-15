import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationHotel {
  late String id;
  late LocationData location;

  LocationHotel(String id, double latitude, double longitude) {
    this.id = id;
    location =
        LocationData.fromMap({'latitude': latitude, 'longitude': longitude});
  }

  bool compareTo(LocationHotel locationArgument, LocationData myLocation) {
    double distanceThis = sqrt(pow((myLocation.latitude! - this.location.latitude!), 2) + pow((myLocation.longitude! - this.location.longitude!), 2));
    double distanceArgument = sqrt(pow((myLocation.latitude! - locationArgument.location.latitude!), 2) + pow((myLocation.longitude! - locationArgument.location.longitude!), 2));
    return distanceThis < distanceArgument ? true : false;
  }
}
