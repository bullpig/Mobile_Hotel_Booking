import 'package:flutter/material.dart';
import 'package:hotel_booking/models/district.dart';

class SeeAllScreen extends StatefulWidget {
  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chọn quận/huyện',
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
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /*Text(
            'Chọn quận/huyện bạn muốn xem',
            
          ),*/
          Container(
            child: ListView.builder(
              itemCount: districts.length,
              padding: EdgeInsets.only(top: 0.0),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(districts[index]),
                  onTap: () {},
                );
              }
            )
          ),

        ],
      ),

    );
  }
}