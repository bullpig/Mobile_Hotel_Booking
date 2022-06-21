import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/models/hotel_model.dart';

import '../screens/hotelDetails.dart';
import '../utils/utils.dart';

class ListHotels extends StatelessWidget {
  List<ShortenHotel> listHotel;
  ListHotels({Key? key, required this.listHotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
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
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                height: 220.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(140.0, 5.0, 5.0, 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              hotel.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              hotel.address,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: buildRatingStars(hotel.rating),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: hotel.rooms
                                    .map(
                                      (room) => Container(
                                        width: 160.0,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 216, 236, 241),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          room,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 15.0,
                bottom: 15.0,
                child: hotel.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: hotel.imageUrl,
                        width: 120.0,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/loading.gif',
                        width: 120.0,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
