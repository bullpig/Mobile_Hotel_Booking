class Room {
  String id;
  String hotelId;
  String name;
  String imageUrl;
  String description;
  int priceTwoHours;
  int priceOvernight;
  int priceAllday;

  Room(
      {this.id = "",
      this.hotelId = "",
      this.name = "",
      this.imageUrl = "",
      this.description = "",
      this.priceTwoHours = 0,
      this.priceOvernight = 0,
      this.priceAllday = 0});
}
