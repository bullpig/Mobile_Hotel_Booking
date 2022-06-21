import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String city = "01";
  String searchKey = "";

  late Future<List<ShortenHotel>> futureHotels;

  @override
  void initState() {
    super.initState();
    futureHotels = getSearchHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                searchKey = val.trim();
              });
            },
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<ShortenHotel>>(
        future: futureHotels,
        builder: (context, snapshot) {
          if (searchKey.isNotEmpty && snapshot.hasData) {
            var listHotels = snapshot.data!;
            return ListView.builder(
                itemCount: listHotels.length,
                itemBuilder: (context, index) {
                  var hotel = listHotels[index];
                  if (hotel.name
                      .toLowerCase()
                      .contains(searchKey.toLowerCase())) {
                    return ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HotelDetail(
                            hotelId: hotel.id,
                          ),
                        ),
                      ),
                      title: Text(
                        hotel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        hotel.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: Image(
                        image: CachedNetworkImageProvider(hotel.imageUrl),
                        width: 80.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Container();
                });
            ;
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Container();
        },
      ),
    );
  }
}
