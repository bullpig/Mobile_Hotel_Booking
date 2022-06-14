import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/utils/utils.dart';

class HotelCarousel extends StatefulWidget {
  String cityId;

  HotelCarousel({Key? key, required this.cityId}) : super(key: key);

  @override
  State<HotelCarousel> createState() => HotelCarouselState();
}

class HotelCarouselState extends State<HotelCarousel> {
  List<ShortenHotel> suggestedHotels = tempHotel;

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    getSuggestHotels(widget.cityId).then((value) => setState(() => suggestedHotels = value));
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
              // GestureDetector(
              //   onTap: () {},
              //   child: Text(
              //     'Xem tất cả',
              //     style: TextStyle(
              //       color: Theme.of(context).primaryColor,
              //       fontWeight: FontWeight.w600,
              //       letterSpacing: 1.0,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          height: 300.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestedHotels.length,
            itemBuilder: (BuildContext context, int index) {
              ShortenHotel hotel = suggestedHotels[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetail(
                      hotelId: hotel.id,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 240.0,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 150.0,
                          width: 240.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel.name,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  hotel.address,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.0),
                                buildRatingStars(hotel.rating),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            height: 180.0,
                            width: 220.0,
                            image: (hotel.imageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(hotel.imageUrl)
                                    : AssetImage("assets/images/loading.gif"))
                                as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
