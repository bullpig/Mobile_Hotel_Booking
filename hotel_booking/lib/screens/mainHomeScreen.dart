import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/models/city.dart';
import 'package:hotel_booking/screens/search.dart';
import 'package:hotel_booking/widgets/destination_carsousel.dart';
import 'package:hotel_booking/widgets/hotel_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_controller.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  City currentCity = City();
  late Future<List<City>> futureCities;

  @override
  void initState() {
    super.initState();
    futureCities = getCities();
    getCity().then((value) {
      if (value != null) {
        setState(() {
          currentCity = value;
        });
      } else {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          if (currentCity.id.isEmpty) {
            _displayTextInputDialog(context);
          }
        });
      }
    });
  }

  Future<City?> getCity() async {
    City res = City();

    final prefs = await SharedPreferences.getInstance();
    final String? cityId = prefs.getString("cityId");

    if (cityId == null) {
      return null;
    }

    final String? cityName = prefs.getString("cityName");
    res.id = cityId;
    res.name = cityName!;

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage('assets/images/bookme_small.png'),
                    width: 100.0,
                    // height: 80.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Search()));
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FontAwesomeIcons.locationArrow,
                      size: 15.0,
                      color: Colors.blue,
                    ),
                    GestureDetector(
                      onTap: () {
                        _displayTextInputDialog(context);
                      },
                      child: Text(
                        currentCity.name,
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Text(
                'Bạn muốn tìm gì?',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            DestinationCarousel(
              cityId: currentCity.id,
            ),
            SizedBox(
              height: 20.0,
            ),
            HotelCarousel(
              cityId: currentCity.id,
            ),
          ],
        ),
      ),
    );
  }

  Future _displayTextInputDialog(BuildContext context) async {
    City selectedCity;
    return showDialog(
        context: context,
        barrierDismissible: currentCity.id.isNotEmpty,
        builder: (context) {
          return FutureBuilder<List<City>>(
            future: futureCities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var listCities = snapshot.data!;
                try {
                  var cur = listCities.singleWhere(
                    (element) => element.id == currentCity.id,
                  );
                  selectedCity = cur;
                } catch (e) {
                  selectedCity = listCities[0];
                }

                return AlertDialog(
                  title: Text('Chọn Địa điểm'),
                  content: DropdownButtonFormField<City>(
                    value: selectedCity,
                    items: listCities
                        .map((label) => DropdownMenuItem(
                              child: Text(label.name),
                              value: label,
                            ))
                        .toList(),
                    hint: const Text('Thành phố'),
                    onChanged: (value) {
                      selectedCity = value!;
                    },
                  ),
                  actions: <Widget>[
                    if (currentCity.id.isNotEmpty)
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: 30.0,
                          width: 60.0,
                          child: Center(
                            child: Text(
                              'Hủy',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString("cityId", selectedCity.id);
                        prefs.setString("cityName", selectedCity.name);
                        setState(() {
                          currentCity = selectedCity;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30.0,
                        width: 60.0,
                        child: Center(
                          child: Text(
                            'Chọn',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Container();
            },
          );
        }).then((value) => value);
  }
}
