import 'package:hotel_booking/utils/utils.dart';

class Order {
  String id;
  String hotelId;
  String roomId;
  String hotelName;
  String roomName;
  String roomImageUrl;
  BookingType bookingType;
  DateTime startTime;
  DateTime endTime;
  PaymentType paymentType;
  int totalPayment;
  bool paymentStaus;

  Order({
    this.id = "",
    this.hotelId = "",
    this.hotelName = "",
    this.roomId = "",
    this.roomName = "",
    this.roomImageUrl = "",
    this.bookingType = BookingType.twoHours,
    required this.startTime,
    required this.endTime,
    this.paymentType = PaymentType.checkIn,
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
