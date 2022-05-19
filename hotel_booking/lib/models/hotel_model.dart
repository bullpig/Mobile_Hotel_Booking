class Hotel {
  String imageUrl;
  String name;
  String address;
  String introduction;
  double twohourprice;
  double overnightprice;
  int rating;
  List<String> services;
  String id;

  double longitude;
  double latitude;

  Hotel({
    required this.id,
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
      id: "121",
      imageUrl: 'assets/images/hotel0.jpg',
      name: 'KIM HOTEL',
      address:
          '12 ngõ 75 Cầu Đất, Chương Dương Độ, Hoàn Kiếm, Hà Nội, Việt Nam',
      twohourprice: 175000,
      overnightprice: 300000,
      rating: 5,
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.In porta euismod neque, vel sagittis augue suscipit et. In sapien ipsum, vehicula sit amet ante non, sollicitudin venenatis est.Vivamus imperdiet venenatis tellus eget fringilla.'),
];
