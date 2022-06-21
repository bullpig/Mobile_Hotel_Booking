import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/order.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/bookingDetail.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/screens/listRoomsScreen.dart';
import 'package:readmore/readmore.dart';
import 'selectRoomScreen.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/utils/utils.dart';

class ListOrderScreen extends StatefulWidget {
  @override
  ListOrderState createState() => ListOrderState();
}

class ListOrderState extends State<ListOrderScreen> {
  List<Order> _listOrders = tempOrders;

  @override
  void initState() {
    super.initState();

    asyncInitState();
  }

  void asyncInitState() async {
    getOrders().then((value) => setState(() {
          _listOrders = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Phòng đã đặt',
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Image.asset('assets/images/bookme.png'),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: ListView.builder(
              itemCount: _listOrders.length,
              itemBuilder: (BuildContext context, int index) {
                Order order = _listOrders[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingDetail(order: order),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(140.0, 10.0, 5.0, 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      order.hotelName,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      order.roomName,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Text(
                                      "${formatTime(order.startTime)} - ${formatTime(order.endTime)}",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${order.totalPayment - (order.totalDiscount ?? 0)}VND ",
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (order.paymentStaus)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 12,
                                        )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20.0,
                        top: 10.0,
                        bottom: 15.0,
                        child: order.roomImageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: order.roomImageUrl,
                                width: 120.0,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/loading.gif",
                                width: 120.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ],
                  ),
                );
              }),
        )));
  }
}
