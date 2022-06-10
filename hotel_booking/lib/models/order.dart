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
    id: "",
    hotelId: "",
    hotelName: "Temp Hotel",
    roomId: "",
    roomName: "Phong VIP",
    roomImageUrl:
        "https://go2joy.s3-ap-southeast-1.amazonaws.com/hotel/1190_1565152182487/2_1_182_1566199339936.jpg",
    bookingType: "twoHours",
    startTime: DateTime(2022, 6, 10, 20, 0),
    endTime: DateTime(2022, 6, 10, 22, 0),
    paymentType: "checkIn",
    totalPayment: 200000,
    paymentStaus: false,
  )
];
