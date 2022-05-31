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
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.city,
      this.description = "",
      this.totalHotel = 0});
}
