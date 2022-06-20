import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final services = {
  "Parking": Icons.local_parking,
  "Pool": Icons.pool,
  "Bath": Icons.bathtub,
  "Bar": Icons.local_drink,
  "Wifi": Icons.wifi,
  "Gym": Icons.fitness_center,
  "Elevator": Icons.elevator,
  "NETFLIX": Icons.camera_roll,
};

String defaultImageUrl =
    "https://res.cloudinary.com/dsy1fdqx2/image/upload/v1655433295/demo/shimmer_wylozh.gif";

enum BookingType { twoHours, overnight, allday }

final bookingTypeToText = {
  BookingType.twoHours: "Theo giờ",
  BookingType.overnight: "Qua đêm",
  BookingType.allday: "Theo ngày",
};

enum PaymentType { checkIn, momo }

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

final paymentTypeLabels = {
  PaymentType.checkIn: 'Thanh toán khi nhận phòng',
  PaymentType.momo: 'Thanh toán bằng Momo',
};
final paymentTypeIcons = {
  PaymentType.checkIn: Icons.money,
  PaymentType.momo: Icons.account_balance_wallet,
};

const maxRatingStar = 5;

Widget buildRatingStars(double currentRating) {
  int integerPart = currentRating.toInt();
  double demicalPart = currentRating - integerPart;
  bool isHalfStar = demicalPart >= 0.5 ? true : false;
  int noStarPart = maxRatingStar - integerPart - (isHalfStar ? 1 : 0);

  var stars = [];
  var createStart = (IconData icon) => Icon(
        icon,
        color: Color.fromRGBO(251, 218, 75, 1),
        size: 16,
      );

  for (int i = 0; i < integerPart; i++) {
    stars.add(createStart(Icons.star));
  }

  if (isHalfStar) {
    stars.add(createStart(Icons.star_half_outlined));
  }

  for (int i = 0; i < noStarPart; i++) {
    stars.add(createStart(Icons.star_outline));
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ...stars,
      Text(
        currentRating == 0.0 ? "Chưa có đánh giá" : currentRating.toString(),
        style: TextStyle(fontSize: 10),
      )
    ],
  );
}

DateTime getTwoHoursInitTime() {
  final currentTime = DateTime.now();

  if (currentTime.isAfter(
      DateTime(currentTime.year, currentTime.month, currentTime.day, 20, 0))) {
    final nextDate = currentTime.add(Duration(days: 1));
    return DateTime(nextDate.year, nextDate.month, nextDate.day, 8, 0);
  }

  if (currentTime.isBefore(
      DateTime(currentTime.year, currentTime.month, currentTime.day, 8, 0))) {
    return DateTime(currentTime.year, currentTime.month, currentTime.day, 8, 0);
  }

  if (currentTime.minute <= 30) {
    return DateTime(currentTime.year, currentTime.month, currentTime.day,
        currentTime.hour, 30);
  } else {
    return DateTime(currentTime.year, currentTime.month, currentTime.day,
        currentTime.add(Duration(hours: 1)).hour, 0);
  }
}

DateTime getOvernightInitTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 22, 0);
}

DateTime getAlldayInitTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 14, 0);
}

String formatTime(DateTime dateTime) {
  return DateFormat("HH:mm dd/MM/yyyy").format(dateTime);
}
