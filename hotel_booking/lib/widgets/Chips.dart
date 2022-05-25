import 'package:flutter/material.dart';

List<String> chipsMobile = [
  'Luxury Hotel',
  'Rooftop Bar',
  'Honeymoon',
  'Covid19StayAway',
];

class Chips extends StatelessWidget {
  final String text;

  const Chips({
    Key ? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Chip(
        shadowColor: Colors.grey[400],
        shape: StadiumBorder(
            side: BorderSide(
          width: 2.0,
        )),
        label: Text(text,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}
