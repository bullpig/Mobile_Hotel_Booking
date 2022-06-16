import 'dart:async';
import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:location/location.dart';

import '../models/hotel_model.dart';
import '../utils/utils.dart';
import 'hotelDetails.dart';
import 'mapScreen.dart';

class NearScreen extends StatefulWidget {
  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearScreen> {
  List<Hotel> listHotel = [];
  Location currentLocation = Location();
  // late LocationData userLocation =
  //     LocationData.fromMap({"latitude": 20.97443, "longitude": 105.84566});
  LocationData userLocation =
      LocationData.fromMap({'latitude': 21.0277633, 'longitude': 105.8341583});
  @override
  void initState() {
    super.initState();
    getLocation();
    asyncInitState();
  }

  void asyncInitState() async {
    getHotelSortByLocation(userLocation)
        .then((value) => setState(() => listHotel = value));
  }

  Future<void> getLocation() async {
    var loca = await currentLocation.getLocation();

    currentLocation.onLocationChanged.listen((LocationData loc) {
      if (loc.latitude != userLocation.latitude ||
          loc.longitude != userLocation.longitude) {
        if (this.mounted) {
          setState(() {
            userLocation = loc;
          });
          print(userLocation.latitude);
          print(userLocation.longitude);
        }
      }
    });
  }

  // void run() async {
  //   await getLocation();
  //   asyncInitState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gần đây',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Image.asset('assets/images/bookme.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.red,
            // size: 25.0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen.fromListHotel(listHotel),
              ),
            ),
          ),
          
        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(20),
        //   child: IconButton(
        //     icon: Icon(Icons.location_on),
        //     color: Colors.red,
        //     // size: 25.0,
        //     onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => MapScreen.fromListHotel(listHotel),
        //       ),
        //     ),
        //   ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 15.0,
            ),
            itemCount: listHotel.length,
            itemBuilder: (BuildContext context, int index) {
              Hotel hotel = listHotel[index];
              String hotelId = hotel.id;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetail(
                      hotelId: hotelId,
                    ),
                  ),
                ).then((value) => setState(() {})),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      height: 230.0,
                      // width: double.infinity,
                      width: 400.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(140.0, 5.0, 5.0, 5.0),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        hotel.name,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        hotel.address,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        maxLines: 3,
                                        // overflow: TextOverflow.ellipsis,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: hotel.rooms
                                              .map(
                                                (room) => Container(
                                                  width: 180.0,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    room,
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
                            Positioned(
                                right: 1.0,
                                bottom: 1.0,
                                child: Row(
                                  children: [
                                    Text(hotel.distance.toString() + "km"),
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 25.0,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.0,
                      top: 15.0,
                      bottom: 15.0,
                      child: Image.network(
                        hotel.imageUrl,
                        height: 180.0,
                        width: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
