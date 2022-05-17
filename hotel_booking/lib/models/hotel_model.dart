class Hotel {
  String imageUrl;
  String name;
  String address;
  String introduction;
  double twohourprice;
  double overnightprice;
  int rating;
  List<String> services;

  double longitude;
  double latitude;

  Hotel({
    this.imageUrl = "",
    this.name = "",
    this.address = "",
    this.introduction = "",
    this.twohourprice = 0.0,
    this.overnightprice = 0.0,
    this.rating = 0,
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.services = const [],
  });
}

List<Hotel> temp_favorite = [
  Hotel(
      imageUrl: 'assets/images/hotel0.jpg',
      name: 'KIM HOTEL',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 175000,
      overnightprice: 300000,
      rating: 5,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
  Hotel(
      imageUrl: 'assets/images/hotel1.jpg',
      name: 'Hotel 1',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 300000,
      overnightprice: 650000,
      rating: 4,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
  Hotel(
      imageUrl: 'assets/images/hotel2.jpg',
      name: 'Hotel 2',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 240000,
      overnightprice: 480000,
      rating: 4,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
];

List<Hotel> temp_hotels = [
  Hotel(
      imageUrl: 'assets/images/hotel0.jpg',
      name: 'KIM HOTEL',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 175000,
      overnightprice: 300000,
      rating: 5,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
  Hotel(
      imageUrl: 'assets/images/hotel1.jpg',
      name: 'Hotel 1',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 300000,
      overnightprice: 650000,
      rating: 4,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
  Hotel(
      imageUrl: 'assets/images/hotel2.jpg',
      name: 'Hotel 2',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 240000,
      overnightprice: 480000,
      rating: 4,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
];
