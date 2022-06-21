import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/models/voucher.dart';
import 'package:hotel_booking/screens/bookingDetail.dart';
import 'package:hotel_booking/screens/selectVoucher.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:hotel_booking/widgets/alldayPicker.dart';
import '../models/hotel_model.dart';
import '../models/order.dart';
import './success.dart';
import '../widgets/overNightpicker.dart';
import '../widgets/twoHoursPicker.dart';
import 'listRoomsScreen.dart';
import 'package:momo_vn/momo_vn.dart';

class SelectRoomScreen extends StatefulWidget {
  final Hotel hotel;
  SelectRoomScreen({Key? key, required this.hotel}) : super(key: key);
  @override
  SelectRoomScreenState createState() => SelectRoomScreenState();
}

class SelectRoomScreenState extends State<SelectRoomScreen> {
  BookingType bookingType = BookingType.twoHours;
  late DateTime startDate;
  late DateTime endDate;

  PaymentType paymentType = PaymentType.checkIn;

  late Future<List<Room>> futureRooms;
  Room? currentRoom;

  List<Voucher> listVoucher = [];
  Voucher? currentVoucher;

  @override
  void initState() {
    super.initState();
    startDate = getTwoHoursInitTime();
    endDate = getTwoHoursInitTime().add(const Duration(hours: 2));
    futureRooms = getInitRooms();
  }

  Future<List<Room>> getInitRooms() async {
    listVoucher = await getVouchersByHotel(widget.hotel.id);
    var res = await getAvailableRooms(widget.hotel.id, startDate, endDate)
        .then((value) {
      if (value.isNotEmpty) {
        currentRoom = value[0];
        if (getVouchersForRoom().isNotEmpty) {
          currentVoucher = getVouchersForRoom()[0];
        } else {
          currentVoucher = null;
        }
      } else {
        currentRoom = null;
        currentVoucher = null;
      }
      return value;
    });
    if (res.isNotEmpty) {
      currentRoom = res[0];
      var vouchers = getVouchersForRoom();
      if (vouchers.isNotEmpty) {
        currentVoucher = vouchers[0];
      } else {
        currentVoucher = null;
      }
    } else {
      currentRoom = null;
      currentVoucher = null;
    }
    return res;
  }

  void getListRooms() async {
    print("getListRooms called");
    futureRooms =
        getAvailableRooms(widget.hotel.id, startDate, endDate).then((value) {
      if (value.isNotEmpty) {
        currentRoom = value[0];
        var vouchers = getVouchersForRoom();
        if (vouchers.isNotEmpty) {
          currentVoucher = vouchers[0];
        } else {
          currentVoucher = null;
        }
      } else {
        currentRoom = null;
        currentVoucher = null;
      }
      return value;
    });
  }

  List<Voucher> getVouchersForRoom() {
    return listVoucher
        .where((element) =>
            element.appliedRooms!.contains(currentRoom!.id) || element.isForAll)
        .toList();
  }

  void setDate(DateTime _startDate, DateTime _endDate) {
    setState(() {
      startDate = _startDate;
      endDate = _endDate;
      getListRooms();
    });
  }

  void onPressConfirm() async {
    if (currentRoom == null) {
      return;
    }
    String orderId = await createBooking(
      widget.hotel.id,
      currentRoom!.id,
      bookingType,
      startDate,
      endDate,
      paymentType,
      getTotalPayment(),
      false,
      currentVoucher?.id,
      getDiscount(),
    );
    if (orderId.isNotEmpty) {
      var order = Order(
        id: orderId,
        hotelId: widget.hotel.id,
        hotelName: widget.hotel.name,
        roomId: currentRoom!.id,
        roomName: currentRoom!.name,
        roomImageUrl: currentRoom!.imageUrl,
        bookingType: bookingType,
        startTime: startDate,
        endTime: endDate,
        paymentType: paymentType,
        totalPayment: getTotalPayment(),
        paymentStaus: false,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetail(
            order: order,
            routeFrom: "selectRoom",
          ),
        ),
      );
      Fluttertoast.showToast(
          msg: "Đặt phòng thành công!", toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: "Đặt phòng thất bại!", toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 30.0,
              color: Colors.grey,
              onPressed: () => Navigator.pop(context),
            ),
            title: Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.hotel.name,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'CHỌN THỜI GIAN',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bookingType = BookingType.twoHours;
                                startDate = getTwoHoursInitTime();
                                endDate = getTwoHoursInitTime()
                                    .add(const Duration(hours: 2));
                                getListRooms();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Giờ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: bookingType == BookingType.twoHours
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bookingType = BookingType.overnight;
                                startDate = getOvernightInitTime();
                                endDate = getOvernightInitTime()
                                    .add(const Duration(hours: 12));
                                getListRooms();
                              });
                            },
                            child: Container(
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Qua Đêm',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: bookingType == BookingType.overnight
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bookingType = BookingType.allday;
                                startDate = getAlldayInitTime();
                                endDate = getAlldayInitTime()
                                    .add(const Duration(hours: 22));
                                getListRooms();
                              });
                            },
                            child: Container(
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Cả ngày',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: bookingType == BookingType.allday
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    getTimePicker(bookingType),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              FutureBuilder<List<Room>>(
                future: futureRooms,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var listRoom = snapshot.data!;
                    return Column(
                      children: [
                        Container(
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
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CHỌN PHÒNG',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ListRommsScreen(
                                              listRooms: listRoom,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() => currentRoom = value);
                                          }
                                        });
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 16, left: 8),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    currentRoom?.name ??
                                                        "Không có phòng phù hợp",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.blue,
                                                  ),
                                                ]),
                                          )),
                                    ),
                                  ])),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
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
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CHỌN VOUCHER',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SelectVoucher(
                                              roomId: currentRoom!.id,
                                              listVoucers: listVoucher,
                                              currentVoucher: currentVoucher,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (value != null) {
                                            setState(
                                                () => currentVoucher = value);
                                            print(value.name);
                                          }
                                          setState(() {
                                            currentVoucher = value;
                                          });
                                        });
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 16, left: 8),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    currentVoucher?.name ??
                                                        "Chưa chọn voucher",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.blue,
                                                  ),
                                                ]),
                                          )),
                                    )
                                  ])),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
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
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'CHỌN PHƯƠNG THỨC THANH TOÁN',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              for (var type in paymentTypeLabels.keys)
                                ListTile(
                                  leading: Radio<PaymentType>(
                                    value: type,
                                    activeColor: Colors.blue,
                                    groupValue: paymentType,
                                    onChanged: (PaymentType? value) {
                                      setState(() {
                                        paymentType = value!;
                                      });
                                    },
                                  ),
                                  title: Text(
                                    paymentTypeLabels[type]!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Icon(
                                    paymentTypeIcons[type]!,
                                    color: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chính sách nhận phòng',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Giờ bắt đầu theo giờ: từ 8:00',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Giờ qua đêm: 22: 00 ~ 10:00',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Giờ theo ngày: 14:00 ~ 12:00',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Không được huỷ phòng trong vòng 1.0 tiếng trước giờ nhận phòng',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (currentRoom != null)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0, 10.0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng tiền phòng:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "${getTotalPayment()}VND",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (currentVoucher != null)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0, 5.0, 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mã giảm giá:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "-${getDiscount()}VND",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (currentRoom != null)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0, 10.0, 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng thanh toán:',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${getTotalPayment() - getDiscount()}VND",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RaisedButton(
                            disabledColor: Theme.of(context).disabledColor,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Container(
                              height: 50.0,
                              child: Center(
                                child: Text(
                                  'Xác nhận',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            onPressed:
                                (currentRoom == null) ? null : onPressConfirm,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return Container();
                },
              ),
            ],
          ),
        ));
  }

  Widget getTimePicker(BookingType bookingType) {
    switch (bookingType) {
      case BookingType.twoHours:
        return TwoHoursPicker();

      case BookingType.overnight:
        return OverNightPicker();

      case BookingType.allday:
        return AllDayPicker();
    }
  }

  int getTotalPayment() {
    switch (bookingType) {
      case BookingType.twoHours:
        return currentRoom!.priceTwoHours;
      case BookingType.overnight:
        return currentRoom!.priceOvernight;
      case BookingType.allday:
        var totalDays = daysBetween(startDate, endDate);
        return totalDays * currentRoom!.priceAllday;
    }
  }

  int getDiscount() {
    if (currentVoucher == null) {
      return 0;
    }
    switch (currentVoucher!.type) {
      case VoucherType.percent:
        var totalPayment = getTotalPayment();
        var discount =
            (totalPayment * currentVoucher!.discountValue / 100).toInt();
        return discount > currentVoucher!.maxDiscount!
            ? currentVoucher!.maxDiscount!
            : discount;
      case VoucherType.fixed:
        return currentVoucher!.discountValue;
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
