import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/models/hotel_model.dart';

import '../screens/hotelDetails.dart';
import '../utils/utils.dart';

class HorizontalListHotels extends StatelessWidget {
  List<ShortenHotel> listHotel;
  HorizontalListHotels({Key? key, required this.listHotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: listHotel.length,
      itemBuilder: (BuildContext context, int index) {
        ShortenHotel hotel = listHotel[index];
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
    );
  }
}
