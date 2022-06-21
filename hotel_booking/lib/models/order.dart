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
  String? voucherId;
  int? totalDiscount;

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
    this.voucherId,
    this.totalDiscount,
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

int getFinalPayment(Order order) {
  return order.totalPayment - (order.totalDiscount ?? 0);
}
