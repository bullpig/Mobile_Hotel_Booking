// ignore_for_file: unnecessary_this

import './hotel_model.dart';
import '../api_controller.dart';

class Destination {
  String id;
  String imageUrl;
  String name;
  String description;
  String city;
  int totalHotel;

  Destination(
      {this.id = "",
      this.imageUrl = "",
      this.name = "",
      this.city = "",
      this.description = "",
      this.totalHotel = 0});
}

List<Destination> tempDestination = [
  Destination(),
  Destination(),
];
