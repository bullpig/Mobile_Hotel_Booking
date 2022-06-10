import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/order.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/screens/listRoomsScreen.dart';
import 'package:readmore/readmore.dart';
import '../screens/paymentScreen.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/utils/utils.dart';

class ListOrderScreen extends StatefulWidget {
  @override
  ListOrderState createState() => ListOrderState();
}

class ListOrderState extends State<ListOrderScreen> {
  List<Order> _listOrders = [];

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
            style: TextStyle(color: Theme.of(context).primaryColor),
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
          child: ListView.builder(
              itemCount: _listOrders.length,
              itemBuilder: (BuildContext context, int index) {
                Order order = _listOrders[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetail(
                        hotel: Hotel(),
                      ),
                    ),
                  ).then((value) => setState(() {})),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                        height: 100.0,
                        // width: double.infinity,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(140.0, 5.0, 5.0, 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${order.totalPayment}VND",
                                            style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20.0,
                        top: 20.0,
                        bottom: 15.0,
                        child: Image.network(
                          order.roomImageUrl,
                          height: 80.0,
                          width: 120.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
