import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/selectRoomScreen.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:intl/intl.dart';
import '../screens/selectRoomScreen.dart';

class AllDayPicker extends StatefulWidget {
  static const String idScreen = 'allday';

  @override
  _AllDatePickerState createState() => _AllDatePickerState();
}

class _AllDatePickerState extends State<AllDayPicker> {
  late DateTimeRange _dateRange;

  late SelectRoomScreenState? parentState;

  @override
  void initState() {
    super.initState();
    parentState = context.findAncestorStateOfType<SelectRoomScreenState>();
    initTime();
   
  }

  void initTime() {
    final startDate = getAlldayInitTime();
    final endDate = startDate.add(Duration(hours: 22));

    _dateRange = DateTimeRange(start: startDate, end: endDate);
  }

  void setDateRange(DateTimeRange dateRange) {
    setState(() {
      final startDate = DateTime(dateRange.start.year, dateRange.start.month,
          dateRange.start.day, 14, 0);
      final endDate = DateTime(
          dateRange.end.year, dateRange.end.month, dateRange.end.day, 12, 0);
      _dateRange = DateTimeRange(start: startDate, end: endDate);
    });
    parentState?.setState(() {
      parentState?.startDate = _dateRange.start;
      parentState?.endDate = _dateRange.end;
    });
    parentState?.setDate(_dateRange.start, _dateRange.end);
  }

  String getFrom() {
    return DateFormat('dd/MM/yyyy').format(_dateRange.start);
  }

  String getUntil() {
    return DateFormat('dd/MM/yyyy').format(_dateRange.end);
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
    final newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: _dateRange,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 30)));
    if (newDateRange == null) {
      return;
    }

    setDateRange(newDateRange);
  }
}
