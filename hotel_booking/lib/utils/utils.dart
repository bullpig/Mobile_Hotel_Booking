import 'package:flutter/material.dart';

final services = {
  "parking": Icons.local_parking,
  "pool": Icons.pool,
  "bath": Icons.bathtub,
  "bar": Icons.local_drink,
  "wifi": Icons.wifi,
  "gym": Icons.fitness_center,
};

enum BookType {
  TWO_HOURS,
  OVERNIGHT,
  ALLDAY
}

enum PaymentType { checkIn }

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
