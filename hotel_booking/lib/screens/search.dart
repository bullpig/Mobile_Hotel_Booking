import 'package:flutter/material.dart';
import 'package:hotel_booking/widgets/destination_carsousel.dart';
import 'package:hotel_booking/widgets/Chips.dart';
import 'package:hotel_booking/widgets/stickyLabels.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String city = "01";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tìm kiếm',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Text(
          //     'Xin chào! Bạn muốn tìm gì?',
          //     style: TextStyle(
          //       fontSize: 32.0,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0, color: Color.fromARGB(255, 113, 138, 193),),
                    borderRadius: BorderRadius.circular(10.0),),
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'Nhập khách sạn, thành phố, địa chỉ...',
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[400],
                  )),
                  // onChanged: ,
            ),
          ),
          StickyLabel(
            text: 'Từ khoá phổ biến',
            textColor: Theme.of(context).primaryColor,
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, left: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Widget>.generate(
                  chipsMobile.length,
                  (int index) {
                    return Chips(text: chipsMobile[index]);
                  },
                ),
              ),
            ),
          ),
          // StickyLabel(
          //   text: 'TOP điểm đến hấp dẫn',
          //   textColor: Theme.of(context).primaryColor,
          // ),
          SizedBox(height: 20.0),
          DestinationCarousel(city: city,),
        ],
      ),
    );
  }
}
