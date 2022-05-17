import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:hotel_app/screens/checkoutScreen.dart';
import '../screens/destinationScreen.dart';
import 'package:hotel_booking/screens/homeScreen.dart';
// import 'package:hotel_app/screens/nearbyScreen.dart';
// import 'package:hotel_app/models/district.dart';
// import 'package:hotel_app/screens/seeallScreen.dart';
import '../api_controller.dart';

import '../models/destination_model.dart';

class DestinationCarousel extends StatefulWidget {
  const DestinationCarousel({Key? key}) : super(key: key);

  @override
  State<DestinationCarousel> createState() => _DestinationCarousel();
}

class _DestinationCarousel extends State<DestinationCarousel> {
  final Future<List<Destination>> _destination = getDestination();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phổ biến',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              TextButton(
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  onPressed: () => {} //Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => SeeAllScreen(),
                  //   ),
                  // ),
                  ),
            ],
          ),
        ),
        Container(
            height: 300.0,
            child: FutureBuilder<List<Destination>>(
              future:
                  _destination, // a previously-obtained Future<String> or null
              builder: (BuildContext context,
                  AsyncSnapshot<List<Destination>> snapshot) {
                print("Destination called");
                if (snapshot.hasData) {
                  var destinationData = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: destinationData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Destination destination = destinationData![index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DestinationScreen(
                              destination: destination,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          width: 210.0,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                bottom: 15.0,
                                child: Container(
                                  height: 200.0,
                                  width: 180.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${destination.hotels.length} khách sạn',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        Text(
                                          destination.description,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
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
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: destination.imageUrl,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          destination.imageUrl,
                                          height: 180.0,
                                          width: 180.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 10.0,
                                      bottom: 10.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            destination.city,
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
                                                size: 10.0,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                destination.country,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ))
      ],
    );
  }
}
