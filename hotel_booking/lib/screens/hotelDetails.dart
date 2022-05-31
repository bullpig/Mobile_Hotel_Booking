import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/listRoomsScreen.dart';
import 'package:readmore/readmore.dart';
import '../screens/paymentScreen.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/utils/utils.dart';

class HotelDetail extends StatefulWidget {
  final Hotel hotel;
  HotelDetail({required this.hotel});
  @override
  _HotelDetailState createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  bool _isFavorite = false;
  List<Room> _listRooms = const [];
  Room _currentRoom = Room();
  int _userRating = 0;

  final ScrollController _hideButtonController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    asyncInitState();
  }

  void asyncInitState() async {
    getHotelFavoriteStatus(widget.hotel.id)
        .then((value) => setState(() => _isFavorite = value));
    getRoomsByHotel(widget.hotel.id).then((value) {
      setState(() {
        _listRooms = value;
        _currentRoom = value[0];
      });
    });
    getUserRating(widget.hotel.id).then((value) {
      setState(() {
        _userRating = value;
      });
    });
  }

  void _setUserRating(int rating) {
    setState(() {
      _userRating = rating;
      setUserRating(widget.hotel.id, rating)
          .then((value) => _reloadHotelRating());
    });
  }

  void _reloadHotelRating() {
    getHotelRating(widget.hotel.id)
        .then((value) => setState(() => widget.hotel.rating = value));
  }

  Widget _buildVoteRating(int currentRating) {
    var stars = [];
    var createStart = (IconData icon, int rating) => InkWell(
          onTap: () {
            if (rating == _userRating) {
              _setUserRating(0);
            } else {
              _setUserRating(rating);
            }
          },
          child: Icon(
            icon,
            color: Color.fromRGBO(251, 218, 75, 1),
            size: 32,
          ),
        );

    for (int i = 0; i < currentRating; i++) {
      stars.add(createStart(Icons.star, i + 1));
    }

    for (int i = 0; i < maxRatingStar - currentRating; i++) {
      stars.add(createStart(Icons.star_outline, currentRating + i + 1));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [...stars],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        controller: _hideButtonController,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 240,
                child: Hero(
                  tag: widget.hotel.imageUrl,
                  child: ClipRRect(
                    //borderRadius: BorderRadius.circular(30.0),
                    child: Image.network(
                      widget.hotel.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 30.0,
                    color: Colors.white70,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
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
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hotel.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
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
                          height: 8,
                        ),
                        buildRatingStars(widget.hotel.rating),
                        SizedBox(
                          height: 8,
                        ),
                        ReadMoreText(
                          widget.hotel.description,
                          trimLines: 4,
                          colorClickableText: Theme.of(context).primaryColor,
                          moreStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          lessStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ...Show more',
                          trimExpandedText: ' Show less',
                          delimiter: "",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
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
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.hotel.services
                          .map((e) => Wrap(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                              spreadRadius: 2,
                                            )
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          services[e],
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(e),
                                    ],
                                  ),
                                  SizedBox(width: 5)
                                ],
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chọn phòng',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListRommsScreen(
                                  listRooms: _listRooms,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                setState(() => _currentRoom = value);
                              }
                            });
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 8, right: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _currentRoom.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ]),
                              )),
                        )
                      ]))
            ],
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 32, bottom: 32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đánh giá của bạn',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, left: 8, right: 8),
                              child: _buildVoteRating(_userRating),
                            ))
                      ]))
            ],
          ),
          SizedBox(
            height: 32,
          ),
        ],
      )),
      floatingActionButton: _isVisible
          ? Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    await setHotelFavoriteStatus(widget.hotel.id, _isFavorite);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(left: 32, top: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Theme.of(context).accentColor,
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          hotelName: widget.hotel.name,
                          room: _currentRoom,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(minWidth: 280),
                    height: 60,
                    margin: EdgeInsets.only(top: 16, left: 16),
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
