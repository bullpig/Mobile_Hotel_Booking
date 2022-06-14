import 'package:hotel_booking/utils/utils.dart';

class Order {
  String id;
  String hotelId;
  String roomId;
  String hotelName;
  String roomName;
  String roomImageUrl;
  String bookingType;
  DateTime startTime;
  DateTime endTime;
  String paymentType;
  int totalPayment;
  bool paymentStaus;

  Order({
    this.id = "",
    this.hotelId = "",
    this.hotelName = "",
    this.roomId = "",
    this.roomName = "",
    this.roomImageUrl = "",
    this.bookingType = "",
    required this.startTime,
    required this.endTime,
    this.paymentType = "",
    this.totalPayment = 0,
    this.paymentStaus = false,
  });
}

var tempOrders = [
  Order(
    startTime: DateTime(0),
    endTime: DateTime(0),
  ),
  Order(
    startTime: DateTime(0),
    endTime: DateTime(0),
  ),
  Order(
    startTime: DateTime(0),
    endTime: DateTime(0),
  ),
];
