class Hotel {
  String imageUrl;
  String name;
  String address;
  String introduction;
  double twohourprice;
  double overnightprice;
  int rating;
  // double longitude;
  // double latitude;

  Hotel({
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.introduction,
    required this.twohourprice,
    required this.overnightprice,
    required this.rating,
    // required this.longitude,
    // required this.latitude,
  });
}

List<Hotel> temp_favorite = [];

List<Hotel> temp_hotels = [
  Hotel(
      imageUrl: 'assets/images/hotel0.jpg',
      name: 'KIM HOTEL',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 175,
      overnightprice: 300,
      rating: 5,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
  Hotel(
      imageUrl: 'assets/images/hotel1.jpg',
      name: 'Hotel 1',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 300,
      overnightprice: 652,
      rating: 4,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
  Hotel(
      imageUrl: 'assets/images/hotel2.jpg',
      name: 'Hotel 2',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 240,
      overnightprice: 480,
      rating: 4,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
];
