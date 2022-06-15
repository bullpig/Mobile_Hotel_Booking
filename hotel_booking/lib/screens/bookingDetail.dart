import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/constants.dart';
import 'package:hotel_booking/models/order.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:hotel_booking/widgets/alldayPicker.dart';
import 'package:momo_vn/momo_vn.dart';
import '../models/hotel_model.dart';
import './success.dart';
import '../widgets/overNightpicker.dart';
import '../widgets/twoHoursPicker.dart';
import 'homeScreen.dart';
import 'listRoomsScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingDetail extends StatefulWidget {
  final Order order;

  final String routeFrom;

  BookingDetail({required this.order, this.routeFrom = "orderList", Key? key})
      : super(key: key);
  @override
  BookingDetailState createState() => BookingDetailState();
}

class BookingDetailState extends State<BookingDetail> {
  late MomoVn _momoPay;
  late PaymentResponse _momoPaymentResult;
  late String _paymentStatus;

  @override
  void initState() {
    super.initState();
    momoInit();
  }

  void momoInit() {
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _paymentStatus = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 30.0,
            color: Colors.grey,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Chi tiết đặt phòng',
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView(children: [
          SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                CachedNetworkImage(
                  imageUrl: widget.order.roomImageUrl,
                  placeholder: (context, url) =>
                      Image.asset("assets/images/loading.gif"),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.hotelName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Loại phòng: ${widget.order.roomName}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Hình thức đặt: ${bookingTypeToText[widget.order.bookingType]}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Thời gian nhận phòng: ${formatTime(widget.order.startTime)}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Thời gian trả phòng: ${formatTime(widget.order.endTime)}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thông tin thanh toán",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Tổng số thanh toán: ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.order.totalPayment}VND",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Hình thức thanh toán: ${paymentTypeLabels[widget.order.paymentType]}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Tình trạng thanh toán: ${widget.order.paymentStaus ? 'Đã thanh toán' : 'Chưa thanh toán'}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (!widget.order.paymentStaus &&
              widget.order.paymentType != PaymentType.checkIn)
            Padding(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: ElevatedButton(
                onPressed: () {
                  MomoPaymentInfo options = MomoPaymentInfo(
                      merchantName: "Book Me",
                      appScheme: "momoamei20220613",
                      merchantCode: 'MOMOAMEI20220613',
                      partnerCode: 'MOMOAMEI20220613',
                      amount: widget.order.totalPayment,
                      orderId: widget.order.id,
                      orderLabel:
                          "${widget.order.hotelName} - ${widget.order.roomName}",
                      merchantNameLabel: "Book Me",
                      fee: 0,
                      description: 'Thanh toan dat phong',
                      partner: 'Book Me',
                      isTestMode: true);
                  try {
                    _momoPay.open(options);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      'Thanh toán',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.blue,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: OutlinedButton(
              onPressed: () {
                if (widget.routeFrom == "selectRoom") {
                  Navigator.pop(context);
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetail(
                      hotelId: widget.order.hotelId,
                    ),
                  ),
                );
              },
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    'Xem khách sạn',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  width: 1.0,
                  color: Colors.blue,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          if (widget.routeFrom == "selectRoom")
            Padding(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(),
                      ),
                      (route) => false);
                },
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      'Màn hình chính',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.blue,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 16,
          ),
        ]));
  }

  @override
  void dispose() {
    super.dispose();
    _momoPay.clear();
  }

  void _setState() {
    _paymentStatus = 'Đã chuyển thanh toán';
    if (_momoPaymentResult.isSuccess == true) {
      _paymentStatus += "\nTình trạng: Thành công.";
      _paymentStatus +=
          "\nSố điện thoại: " + _momoPaymentResult.phoneNumber.toString();
      _paymentStatus += "\nExtra: " + _momoPaymentResult.extra!;
      _paymentStatus += "\nToken: " + _momoPaymentResult.token.toString();
    } else {
      _paymentStatus += "\nTình trạng: Thất bại.";
      _paymentStatus += "\nExtra: " + _momoPaymentResult.extra.toString();
      _paymentStatus += "\nMã lỗi: " + _momoPaymentResult.status.toString();
    }
  }

  void _handlePaymentSuccess(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    updatePaymentStatus(widget.order.id, true).then((value) {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Success(),
          ),
        );
      }
    });
    Fluttertoast.showToast(
        msg: "Thanh toán thành công!", toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    Fluttertoast.showToast(
        msg: "Thanh toán thất bại!", toastLength: Toast.LENGTH_SHORT);
  }
}
