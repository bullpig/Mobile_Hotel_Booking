import 'package:flutter/material.dart';

final services = {
  "Parking": Icons.local_parking,
  "Pool": Icons.pool,
  "Bath": Icons.bathtub,
  "Bar": Icons.local_drink,
  "Wifi": Icons.wifi,
  "Gym": Icons.fitness_center,
  "Elevator" : Icons.elevator,
  "NETFLIX" : Icons.camera_roll, 
};

enum BookingType { twoHours, overnight, allday }

enum PaymentType { checkIn }

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

final paymentTypeLabels = {
  PaymentType.checkIn: 'Thanh toán tại khách sạn',
};
final paymentTypeIcons = {
  PaymentType.checkIn: Icons.money,
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
