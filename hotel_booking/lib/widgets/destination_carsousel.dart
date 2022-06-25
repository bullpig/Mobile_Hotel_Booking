import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/seeallScreen.dart';
import './destinationItem.dart';
import '../api_controller.dart';
import '../models/destination_model.dart';

class DestinationCarousel extends StatefulWidget {
  final String cityId;

  const DestinationCarousel({Key? key, required this.cityId}) : super(key: key);

  @override
  State<DestinationCarousel> createState() => _DestinationCarousel();
}

class _DestinationCarousel extends State<DestinationCarousel> {
  late Future<List<Destination>> futureDestinations;

  @override
  void initState() {
    super.initState();
    futureDestinations = getDestination(widget.cityId);
  }

  @override
  void didUpdateWidget(covariant DestinationCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cityId != widget.cityId) {
      futureDestinations = getDestination(widget.cityId);
    }
  }

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
              FutureBuilder<List<Destination>>(
                future: futureDestinations,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var listDestination = snapshot.data!;
                    return TextButton(
                        child: Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SeeAllScreen(
                                    destinations: listDestination,
                                  ),
                                ),
                              ),
                            });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Container(
            height: 300.0,
            child: FutureBuilder<List<Destination>>(
              future: futureDestinations,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var listDestination = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listDestination.length,
                    itemBuilder: (BuildContext context, int index) {
                      Destination destination = listDestination[index];
                      return DestinationItem(destination: destination);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DestinationItem(destination: tempDestination[0]),
                    DestinationItem(destination: tempDestination[0])
                  ],
                );
              },
            ))
      ],
    );
  }
}
