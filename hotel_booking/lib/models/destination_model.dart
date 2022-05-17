// ignore_for_file: unnecessary_this

import './hotel_model.dart';
import '../api_controller.dart';

class Destination {
  String imageUrl;
  String city;
  String country;
  String description;
  List<Hotel> hotels = [];

  Destination(
      {required this.imageUrl,
      required this.city,
      required this.country,
      required this.description});

  Future<void> getterHotels() async {
    this.hotels = await getHotelsByDestination(this.city);
  }
}

List<Destination> destinations = [];

void loadDataOfDestinations() {
    destinations = [
    Destination(imageUrl: 'assets/images/venice.jpg', city: 'Hoàn Kiếm', country: 'Hà Nội', description: 'Ghé thăm Hoàn Kiếm để có một chuyến phiêu lưu kỳ thú và khó quên.'),
    Destination(imageUrl: 'assets/images/paris.jpg', city: 'Cầu Giấy', country: 'Hà Nội', description: 'Ghé thăm Cầu Giấy để có một chuyến phiêu lưu kỳ thú và khó quên'),
    Destination(imageUrl: 'assets/images/newdelhi.jpg', city: 'Hoàng Mai', country: 'Hà Nội', description: 'Ghé thăm Hoàng Mai để có một chuyến phiêu lưu kỳ thú và khó quên'),
    Destination(imageUrl: 'assets/images/saopaulo.jpg', city: 'Nam Từ Liêm', country: 'Hà Nội', description: 'Ghé thăm Nam Từ Liêm để có một chuyến phiêu lưu kỳ thú và khó quên'),
    Destination(imageUrl: 'assets/images/newyork.jpg', city: 'Hai Bà Trưng', country: 'Hà Nội', description: 'Ghé thăm Hai Bà Trưng để có một chuyến phiêu lưu kỳ thú và khó quên'),
  ];
}
