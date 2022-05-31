class Room {
  String id;
  String hotelId;
  String name;
  String imageUrl;
  List<String> description;
  int priceTwoHours;
  int priceOvernight;
  int priceAllday;

  Room(
      {this.id = "",
      this.hotelId = "",
      this.name = "",
      this.imageUrl = "",
      this.description = const [],
      this.priceTwoHours = 0,
      this.priceOvernight = 0,
      this.priceAllday = 0});
}
