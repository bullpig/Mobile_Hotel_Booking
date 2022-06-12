import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/constants.dart';
import 'package:hotel_booking/models/order.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:hotel_booking/widgets/alldayPicker.dart';
import '../models/hotel_model.dart';
import './success.dart';
import '../widgets/overNightpicker.dart';
import '../widgets/twoHoursPicker.dart';
import 'listRoomsScreen.dart';

class BookingDetail extends StatefulWidget {
  final Order order;

  BookingDetail({required this.order, Key? key}) : super(key: key);
  @override
  BookingDetailState createState() => BookingDetailState();
}

class BookingDetailState extends State<BookingDetail> {
  @override
  void initState() {
    super.initState();
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
                        "Hình thức đặt: ${bookingTypeToText[BookingType.values.byName(widget.order.bookingType)]}",
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
                    "Hình thức thanh toán: ${paymentTypeLabels[PaymentType.values.byName(widget.order.paymentType)]}",
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
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: OutlinedButton(
              onPressed: () {
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
          )
        ]));
  }
}
