import './hotel_model.dart';
import '../api_controller.dart';

class Destination {
  String imageUrl;
  String city;
  String country;
  String description;
  List<Hotel> hotels = [];

  Destination ({
    required this.imageUrl,
    required this.city,
    required this.country,
    required this.description
  }) {
    getterHotels();
  }

  Future<void> getterHotels() async {
    this.hotels = await getHotelsByDestination(this.city);
  }

}

List<Destination> destinations = [];

void loadDataOfDestinations() {
    destinations = [
    Destination(imageUrl: 'assets/images/venice.jpg', city: 'Hoàn Kiếm', country: 'Hà Nội', description: 'Visit Hoàn Kiếm for an amazing and unforgettable adventure.'),
    Destination(imageUrl: 'assets/images/paris.jpg', city: 'Cầu Giấy', country: 'Hà Nội', description: 'Visit Cầu Giấy for an amazing and unforgettable adventure.'),
    Destination(imageUrl: 'assets/images/newdelhi.jpg', city: 'Đống Đa', country: 'Hà Nội', description: 'Visit Đống Đa for an amazing and unforgettable adventure.'),
    Destination(imageUrl: 'assets/images/saopaulo.jpg', city: 'Nam Từ Liêm', country: 'Hà Nội', description: 'Visit Hà Nội for an amazing and unforgettable adventure.'),
    Destination(imageUrl: 'assets/images/newyork.jpg', city: 'Hai Bà Trưng', country: 'Hà Nội', description: 'Visit Hà Nội for an amazing and unforgettable adventure.')
  ];
}
