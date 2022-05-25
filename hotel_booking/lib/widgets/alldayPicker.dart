import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/paymentScreen.dart';
import 'package:intl/intl.dart';
import '../screens/paymentScreen.dart';

class AllDayPicker extends StatefulWidget {
  static const String idScreen = 'allday';

  @override
  _AllDatePickerState createState() => _AllDatePickerState();
}

class _AllDatePickerState extends State<AllDayPicker> {
  DateTime currentDate = DateTime.now();
  late final ancestralState;

  String getFrom() {
    return DateFormat('dd/MM/yyyy').format(currentDate);
  }

  String getUntil() {
    return DateFormat('dd/MM/yyyy')
        .format(currentDate.add(const Duration(days: 1)));
  }

  @override
  void initState() {
    super.initState();
    ancestralState = context.findAncestorStateOfType<PaymentScreenState>();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => pickDateRange(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '14:00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    getFrom(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward,
          size: 50.0,
          color: Colors.grey,
        ),
        Container(
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => pickDateRange(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12:00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    getUntil(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future pickDateRange(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: currentDate,
    );

    if (newDate == null) return;

    setState(() {
      currentDate = newDate;
      ancestralState.setState(() {
        
      });
    });
  }
}
