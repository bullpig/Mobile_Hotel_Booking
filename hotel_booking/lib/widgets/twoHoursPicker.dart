import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/paymentScreen.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import '../utils/utils.dart';
import 'package:flutter/widgets.dart';

class TwoHoursPicker extends StatefulWidget {
  static const String idScreen = 'twohours';

  @override
  _TwoHoursPickerState createState() => _TwoHoursPickerState();
}

class _TwoHoursPickerState extends State<TwoHoursPicker> {
  late DateTime nowDate;
  late PaymentScreenState? parentState;
  @override
  void initState() {
    super.initState();
    parentState = context.findAncestorStateOfType<PaymentScreenState>();
    updateTime();
  }

  void updateTime() {
    final currentTime = DateTime.now();

    if (20 < currentTime.hour || currentTime.hour < 8) {
      final nextDate = currentTime.add(Duration(days: 1));
      nowDate = DateTime(nextDate.year, nextDate.month, nextDate.day, 8, 0);
      print("updateTime called");
      print(parentState == null);

      return;
    }

    if (currentTime.minute <= 30) {
      final offset = 30 - currentTime.minute;
      nowDate = DateTime.now().add(Duration(minutes: offset));
    } else {
      final offset = 60 - currentTime.minute;
      nowDate = DateTime.now().add(Duration(minutes: offset));
    }
  }

  void setNowDate(DateTime date) {

  }

  String getHour() {
    return DateFormat('HH:mm').format(nowDate);
  }

  String getHourEnd() {
    return DateFormat('HH:mm').format(nowDate.add(Duration(hours: 2)));
  }

  String getDay() {
    return DateFormat('dd/MM/yyyy').format(nowDate);
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
              onTap: () => pickDateTime(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getHour(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    getDay(),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getHourEnd(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    getDay(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future pickDateTime(BuildContext context) async {
    await pickDate(context).then((value) => pickTime(context, value));
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: nowDate,
        firstDate: nowDate,
        lastDate: DateTime(DateTime.now().year + 5));
    if (newDate == null) return nowDate;
    setState(() {
      nowDate = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        nowDate.hour,
        nowDate.minute,
      );
    });
    return newDate;
  }

  Future pickTime(BuildContext context, DateTime date) async {
    var currentTime = DateTime.now();
    if (currentTime.minute > 30) {
      currentTime = currentTime.add(const Duration(hours: 1));
    }

    final newTime = await showCustomTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(nowDate),
        selectableTimePredicate: (time) =>
            time!.hour >= 8 &&
            (isSameDate(date, currentTime)
                ? time.hour >= currentTime.hour
                : true) &&
            time.hour <= 20 &&
            time.minute % 30 == 0 &&
            ((time.hour == 8) ? time.minute == 0 : true),
        onFailValidation: (context) => log('Unavailable selection'));
    if (newTime == null) return TimeOfDay.fromDateTime(nowDate);
    setState(() {
      nowDate = DateTime(
        date.year,
        date.month,
        date.day,
        newTime.hour,
        newTime.minute,
      );
    });
  }
}
