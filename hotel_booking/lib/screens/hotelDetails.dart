import 'package:flutter/material.dart';
// import 'package:hotel_app/screens/checkoutScreen.dart';
// import 'package:hotel_app/screens/favouriteScreen.dart';
import 'package:hotel_booking/models/hotel_model.dart';
// import 'package:hotel_app/screens/hotelLocationScreen.dart';
// import 'package:hotel_app/screens/seeallScreen.dart';

class HotelDetail extends StatefulWidget {
  final Hotel hotel;
  HotelDetail({required this.hotel});
  @override
  _HotelDetailState createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  String _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                image: DecorationImage(
                  //TODO: replace hotel image here
                  image: NetworkImage(
                      "https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 32,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      iconSize: 30.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    bottom: 20.0,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => HotelLocationScreen(),
                        //   ),
                        // );
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 25.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotel.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.hotel.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.hotel.introduction,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      // fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${widget.hotel.twohourprice}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Hai giờ đầu'),
                        SizedBox(height: 10),
                        Text(
                          '\$${widget.hotel.overnightprice}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Qua đêm'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Đánh giá'),
                        Row(
                          children: [
                            Text(
                              _buildRatingStars(widget.hotel.rating),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tiện ích',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.local_parking,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Parking'),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.pool,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Pool'),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.bathtub,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Bath'),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.local_drink,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Bar'),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.wifi,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Wifi'),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Gym'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (temp_favorite.contains(widget.hotel) == false)
                        temp_favorite.add(widget.hotel);
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).accentColor,
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
                /*Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).accentColor,
                      size: 48.0,
                    ),
                  ),
                ),*/
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => PaymentScreen(
                    //       hotel: widget.hotel,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    width: 240,
                    margin: EdgeInsets.only(
                        top: 18, bottom: 18, right: 16, left: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Đặt ngay',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
