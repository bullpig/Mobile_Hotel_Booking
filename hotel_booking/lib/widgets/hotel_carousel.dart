import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/utils/utils.dart';
import 'package:hotel_booking/widgets/horizontalListHotels.dart';

class HotelCarousel extends StatefulWidget {
  String cityId;

  HotelCarousel({Key? key, required this.cityId}) : super(key: key);

  @override
  State<HotelCarousel> createState() => HotelCarouselState();
}

class HotelCarouselState extends State<HotelCarousel> {
  late Future<List<ShortenHotel>> futureHotels;

  @override
  void initState() {
    super.initState();
    futureHotels = getSuggestHotels(widget.cityId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Nổi bật',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 300.0,
          child: FutureBuilder<List<ShortenHotel>>(
            future: futureHotels,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var suggestedHotels = snapshot.data!;
                return HorizontalListHotels(listHotel: suggestedHotels);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return HorizontalListHotels(listHotel: tempHotel);
            },
          ),
        )
      ],
    );
  }
}
