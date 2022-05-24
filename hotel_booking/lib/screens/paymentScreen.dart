import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:hotel_booking/widgets/alldayPicker.dart';
import '../models/hotel_model.dart';
//import 'package:hotel_app/screens/success.dart';
import '../widgets/overNightpicker.dart';
import '../widgets/twoHoursPicker.dart';

enum Status { first, second, third, fourth }

class PaymentScreen extends StatefulWidget {
  final Hotel hotel;
  PaymentScreen({required this.hotel});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Status _type = Status.first;
  int value = 0;

  final Labels = [
    'Thanh toán tại khách sạn',
    'Internet Banking (Thẻ ATM)',
    'Thẻ tín dụng',
    'Paypal',
  ];
  final LabelsIcon = [
    Icons.money_off,
    Icons.credit_card,
    Icons.payment,
    Icons.account_balance_wallet,
  ];

  final tabs = [
    TwoHoursPicker(),
    OverNightPicker(),
    AllDayPicker(),
  ];

  BookType bookType = BookType.TWO_HOURS;

  @override
  void initState() {
    super.initState();
  }

  String getPrice(int value) {
    if (value == 0) {
      return '\$${widget.hotel.twohourprice}';
    } else {
      return '\$${widget.hotel.overnightprice}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    '${widget.hotel.name} - ${widget.hotel.address}',
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
            height: 10.0,
          ),
          SizedBox(height: 10.0),
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
                            bookType = BookType.TWO_HOURS;
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
                                  color: bookType == BookType.TWO_HOURS
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
                            bookType = BookType.OVERNIGHT;
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
                                color: bookType == BookType.OVERNIGHT
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
                            bookType = BookType.ALLDAY;
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
                                color: bookType == BookType.ALLDAY
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
                tabs[bookType.index],
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
                Text(
                  'CHỌN PHƯƠNG THỨC THANH TOÁN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Radio<Status>(
                    value: Status.first,
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: _type,
                    onChanged: (Status? value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  title: Text(
                    Labels[0],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    LabelsIcon[0],
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: Radio<Status>(
                    value: Status.second,
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: _type,
                    onChanged: (Status? value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  title: Text(
                    Labels[1],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    LabelsIcon[2],
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: Radio<Status>(
                    value: Status.third,
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: _type,
                    onChanged: (Status? value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  title: Text(
                    Labels[2],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    LabelsIcon[2],
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: Radio<Status>(
                    value: Status.fourth,
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: _type,
                    onChanged: (Status? value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  title: Text(
                    Labels[3],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    LabelsIcon[3],
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
                  'Giờ bắt đầu theo giờ: từ 6:00',
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
                  'Giờ theo ngày: 14: 00 ~ 12:00',
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
                  getPrice(bookType.index),
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
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => Success(),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
