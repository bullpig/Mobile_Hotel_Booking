import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/screens/listRoomsScreen.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';
import '../utils/utils.dart';
import '../widgets/listHotels.dart';
//import 'package:hotel_app/screens/hotelDetails.dart';

class DestinationScreen extends StatefulWidget {
  final Destination destination;
  DestinationScreen({required this.destination});
  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  late Future<List<ShortenHotel>> futureHotels;

  @override
  void initState() {
    super.initState();
    futureHotels = getHotelsByDestination(widget.destination.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Hero(
                  tag: widget.destination.imageUrl + "destImg",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.destination.imageUrl,
                      fit: BoxFit.cover,
                      height: 240,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Positioned(
                left: 10.0,
                bottom: 10.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.locationArrow,
                          size: 15.0,
                          color: Colors.white70,
                        ),
                        Text(
                          widget.destination.city,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 25.0,
                ),
              )
            ],
          ),
          Expanded(
            child: FutureBuilder<List<ShortenHotel>>(
              future: futureHotels,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListHotels(listHotel: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return ListHotels(listHotel: tempHotel);
              },
            ),
          )
        ],
      ),
    );
  }
}
