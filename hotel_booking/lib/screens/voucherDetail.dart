import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/models/voucher.dart';
import 'package:hotel_booking/screens/discountedHotels.dart';
import 'package:hotel_booking/screens/homeScreen.dart';
import 'package:hotel_booking/screens/listRoomsScreen.dart';
import 'package:hotel_booking/screens/mapScreen.dart';
import 'package:readmore/readmore.dart';
import 'selectRoomScreen.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:hotel_booking/utils/utils.dart';

class VoucherDetail extends StatefulWidget {
  String voucherId;

  VoucherDetail({Key? key, required this.voucherId}) : super(key: key);

  @override
  _VoucherDetailState createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  late Future<Voucher> futureVoucher;

  final ScrollController _hideButtonController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    futureVoucher = getVoucher(widget.voucherId);
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Voucher>(
      future: futureVoucher,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Voucher voucher = snapshot.data!;
          print(voucher.isForAll);
          return Scaffold(
            body: SafeArea(
                child: ListView(
              controller: _hideButtonController,
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 240,
                      child: Hero(
                        tag: voucher.imageUrl + "voucherImage",
                        child: ClipRRect(
                          child: voucher.imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: voucher.imageUrl,
                                  fit: BoxFit.contain,
                                )
                              : Image.asset('assets/images/loading.gif'),
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
                  ],
                ),
                Row(
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voucher.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
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
                                "Ngày bắt đầu: ${formatTime(voucher.startTime)}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Ngày kết thúc: ${formatTime(voucher.endTime)}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              ReadMoreText(
                                voucher.description,
                                trimLines: 4,
                                colorClickableText:
                                    Theme.of(context).primaryColor,
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                trimMode: TrimMode.Line,
                                trimCollapsedText: ' ...Xem thêm',
                                trimExpandedText: ' Thu gọn',
                                delimiter: "",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 1,
                                width: 100,
                              ),
                              Row(children: <Widget>[
                                Expanded(child: Divider()),
                              ]),
                              Text(
                                "Áp dụng cho: ${voucher.isForAll ? 'Tất cả' : 'Một số'} khách sạn",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            )),
            floatingActionButton: _isVisible
                ? Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (voucher.isForAll) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DiscountedHotelsScreen(
                                voucher: voucher,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Dùng ngay',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          width: 1.0,
                          color: Colors.blue,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
