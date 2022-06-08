import 'package:flutter/material.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:intl/intl.dart';

import '../screens/paymentScreen.dart';

class OverNightPicker extends StatefulWidget {
  static const String idScreen = 'overnight';

  @override
  _OverNightPickerState createState() => _OverNightPickerState();
}

class _OverNightPickerState extends State<OverNightPicker> {
  DateTime currentDate = DateTime.now();
  late PaymentScreenState? parentState;
  @override
  void initState() {
    super.initState();
    parentState = context.findAncestorStateOfType<PaymentScreenState>();
    currentDate = getOvernightInitTime();
  }

  void setCurrentDate(DateTime date) {
    setState(() {
      currentDate = DateTime(date.year, date.month, date.day, 22, 0);
    });
    // parentState?.setState(() {
    //   parentState?.startDate = currentDate;
    //   parentState?.endDate = currentDate.add(const Duration(hours: 12));
    // });
    parentState?.setDate(
        currentDate, currentDate.add(const Duration(hours: 12)));
  }

  String getFrom() {
    return DateFormat('dd/MM/yyyy').format(currentDate);
  }

  String getUntil() {
    return DateFormat('dd/MM/yyyy')
        .format(currentDate.add(const Duration(days: 1)));
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
                    '22:00',
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
                    '10:00',
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
      lastDate: DateTime.now().add(Duration(days: 30)),
      initialDate: currentDate,
    );

    if (newDate == null) return;

    setCurrentDate(newDate);
  }
}
