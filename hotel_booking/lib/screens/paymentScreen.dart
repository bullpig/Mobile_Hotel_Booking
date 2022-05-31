import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/constants.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:hotel_booking/widgets/alldayPicker.dart';
import '../models/hotel_model.dart';
import './success.dart';
import '../widgets/overNightpicker.dart';
import '../widgets/twoHoursPicker.dart';

class PaymentScreen extends StatefulWidget {
  final Room room;
  final String hotelName;
  PaymentScreen({required this.room, required this.hotelName});
  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  BookingType bookingType = BookingType.twoHours;
  DateTime startDate = DateTime(0);
  DateTime endDate = DateTime(0);

  PaymentType paymentType = PaymentType.checkIn;

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
        return widget.room.priceTwoHours;
      case BookingType.overnight:
        return widget.room.priceOvernight;
      case BookingType.allday:
        var totalDays = daysBetween(startDate, endDate);
        return totalDays * widget.room.priceAllday;
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  void initState() {
    super.initState();
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
                        '${widget.hotelName} - ${widget.room.name}',
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
              SizedBox(height: 20.0),
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
                  onPressed: () async {
                    bool bookingStatus = await createBooking(
                      widget.room.hotelId,
                      widget.room.id,
                      bookingType,
                      startDate,
                      endDate,
                      paymentType,
                      getTotalPayment(),
                      false,
                    );
                    if (bookingStatus) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Success(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Đặt phòng thất bại!")));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
