import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readmore/readmore.dart';
import '../models/voucher.dart';
import 'package:hotel_booking/utils/utils.dart';

class ApplyVoucher extends StatefulWidget {
  Voucher voucher;
  String roomId;

  ApplyVoucher({Key? key, required this.voucher, required this.roomId})
      : super(key: key);

  @override
  _ApplyVoucherState createState() => _ApplyVoucherState();
}

class _ApplyVoucherState extends State<ApplyVoucher> {
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
                child: Hero(
                  tag: widget.voucher.imageUrl + "voucherImage",
                  child: ClipRRect(
                    child: widget.voucher.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.voucher.imageUrl,
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
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.voucher.name,
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
                          "Ngày bắt đầu: ${formatTime(widget.voucher.startTime)}",
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
                          "Ngày kết thúc: ${formatTime(widget.voucher.endTime)}",
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
                          widget.voucher.description,
                          trimLines: 4,
                          colorClickableText: Theme.of(context).primaryColor,
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
                          "Áp dụng cho: ${widget.voucher.isForAll ? 'Tất cả' : 'Một số'} khách sạn",
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
              child: canAppliedVoucher(widget.voucher, widget.roomId)
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Áp dụng",
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Không thể áp dụng",
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                    ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
