import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/models/voucher.dart';
import 'package:hotel_booking/screens/applyVoucher.dart';

import 'hotelDetails.dart';

class SelectVoucher extends StatefulWidget {
  List<Voucher> listVoucers;
  String roomId;
  Voucher? currentVoucher;

  SelectVoucher(
      {required this.roomId, required this.listVoucers, this.currentVoucher});

  @override
  _SelectVoucherState createState() => _SelectVoucherState();
}

class _SelectVoucherState extends State<SelectVoucher> {
  Voucher? currentVoucher;

  @override
  void initState() {
    super.initState();
    if (widget.currentVoucher != null) {
      currentVoucher = widget.currentVoucher;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 30.0,
            color: Colors.grey,
            onPressed: () => Navigator.pop(context, currentVoucher),
          ),
          title: Text(
            'Chọn mã giảm giá',
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
            itemCount: widget.listVoucers.length,
            itemBuilder: (context, index) {
              var voucher = widget.listVoucers[index];
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplyVoucher(
                            voucher: voucher,
                            roomId: widget.roomId,
                          ),
                        ),
                      ).then((value) {
                        setState(() {
                          if (value != null && value) {
                            currentVoucher = voucher;
                          }
                        });
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(voucher.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5.0,
                          bottom: 5.0,
                          child: canAppliedVoucher(voucher, widget.roomId)
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (currentVoucher == null ||
                                          currentVoucher! != voucher) {
                                        currentVoucher = voucher;
                                      } else {
                                        currentVoucher = null;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 120,
                                    child: Center(
                                      child: currentVoucher != voucher
                                          ? Text(
                                              "Áp dụng",
                                            )
                                          : Text(
                                              "Đã chọn",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                    ),
                                  ),
                                  style: currentVoucher == voucher
                                      ? ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          side: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        )
                                      : ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                        ),
                                )
                              : ElevatedButton(
                                  onPressed: () {},
                                  child: Container(
                                    width: 120,
                                    child: Center(
                                      child: Text(
                                        "Không thể áp dụng",
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey),
                                ),
                        )
                      ],
                    ),
                  ));
            }),
      ),
      onWillPop: () async {
        Navigator.pop(context, currentVoucher);
        return false;
      },
    );
  }
}
