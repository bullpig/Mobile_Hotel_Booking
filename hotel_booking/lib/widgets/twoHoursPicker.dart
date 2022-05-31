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
    initTime();
  }

  DateTime getInitTime() {
    final currentTime = DateTime.now();

    if (currentTime.isAfter(DateTime(
            currentTime.year, currentTime.month, currentTime.day, 20, 0)) ||
        currentTime.isBefore(DateTime(
            currentTime.year, currentTime.month, currentTime.day, 8, 0))) {
      final nextDate = currentTime.add(Duration(days: 1));
      return DateTime(nextDate.year, nextDate.month, nextDate.day, 8, 0);
    }

    if (currentTime.minute <= 30) {
      return DateTime(currentTime.year, currentTime.month, currentTime.day,
          currentTime.hour, 30);
    } else {
      return DateTime(currentTime.year, currentTime.month, currentTime.day,
          currentTime.add(Duration(hours: 1)).hour, 30);
    }
  }

  void initTime() {
    nowDate = getInitTime();
    parentState?.startDate = nowDate;
    parentState?.endDate = nowDate.add(const Duration(hours: 2));
  }

  void setNowDate(DateTime date) {
    setState(() {
      nowDate = date;
    });
    parentState?.setState(() {
      parentState?.startDate = nowDate;
      parentState?.endDate = nowDate.add(const Duration(hours: 2));
    });
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
    await pickDate(context).then((value) {
      if (value != null) {
        pickTime(context, value);
      }
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: nowDate,
        firstDate: getInitTime(),
        lastDate: getInitTime().add(Duration(days: 30)));
    if (newDate == null) return null;
    setNowDate(DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      nowDate.hour,
      nowDate.minute,
    ));
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
            (time.hour <= 19 || (time.hour == 20 && time.minute == 0)) &&
            time.minute % 30 == 0 &&
            ((time.hour == 8) ? time.minute == 0 : true),
        onFailValidation: (context) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Thời gian không hợp lệ"))));
    if (newTime == null) return TimeOfDay.fromDateTime(nowDate);
    setNowDate(DateTime(
      date.year,
      date.month,
      date.day,
      newTime.hour,
      newTime.minute,
    ));
  }
}
