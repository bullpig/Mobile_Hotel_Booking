// ignore_for_file: unnecessary_this

import './hotel_model.dart';
import '../api_controller.dart';

class Destination {
  String id;
  String imageUrl;
  String name;
  String description;
  String city;
  List<Hotel> hotels = [];

  Destination(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.city,
      this.description = ""});

  Future<void> getterHotels() async {
    this.hotels = await getHotelsByDestination(this.name);
  }
}
