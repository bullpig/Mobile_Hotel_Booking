import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/bookingDetail.dart';
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

  List<Room> _listRooms = const [];
  Room? _currentRoom;

  @override
  void initState() {
    super.initState();
    startDate = getTwoHoursInitTime();
    endDate = getTwoHoursInitTime().add(const Duration(hours: 2));
    getListRooms();
  }

  void getListRooms() async {
    getAvailableRooms(widget.hotel.id, startDate, endDate)
        .then((value) => setState(() {
              _listRooms = value;
              if (_listRooms.isNotEmpty) {
                _currentRoom = _listRooms[0];
              } else {
                _currentRoom = null;
              }
            }));
  }

  void setDate(DateTime _startDate, DateTime _endDate) {
    setState(() {
      startDate = _startDate;
      endDate = _endDate;
      getListRooms();
    });
  }

  void onPressConfirm() async {
    if (_currentRoom == null) {
      return;
    }
    String orderId = await createBooking(
      widget.hotel.id,
      _currentRoom!.id,
      bookingType,
      startDate,
      endDate,
      paymentType,
      getTotalPayment(),
      false,
    );
    if (orderId.isNotEmpty) {
      var order = Order(
        id: orderId,
        hotelId: widget.hotel.id,
        hotelName: widget.hotel.name,
        roomId: _currentRoom!.id,
        roomName: _currentRoom!.name,
        roomImageUrl: _currentRoom!.imageUrl,
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
          builder: (_) => BookingDetail(order: order, routeFrom: "selectRoom",),
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
          body: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 30.0,
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.hotel.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
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
                        'THÔNG TIN THANH TOÁN',
                        style: TextStyle(
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
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CHỌN PHÒNG',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ListRommsScreen(
                                    listRooms: _listRooms,
                                  ),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  setState(() => _currentRoom = value);
                                }
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 16, bottom: 16, left: 8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _currentRoom?.name ??
                                              "Không có phòng phù hợp",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Theme.of(context).primaryColor,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    for (var type in paymentTypeLabels.keys)
                      ListTile(
                        leading: Radio<PaymentType>(
                          value: type,
                          activeColor: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).primaryColor,
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
              if (_currentRoom != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TỔNG CỘNG',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${getTotalPayment()}VND",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  disabledColor: Theme.of(context).disabledColor,
                  color: Theme.of(context).primaryColor,
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
                  onPressed: (_currentRoom == null) ? null : onPressConfirm,
                ),
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
        return _currentRoom!.priceTwoHours;
      case BookingType.overnight:
        return _currentRoom!.priceOvernight;
      case BookingType.allday:
        var totalDays = daysBetween(startDate, endDate);
        return totalDays * _currentRoom!.priceAllday;
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
