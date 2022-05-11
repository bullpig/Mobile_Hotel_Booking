import 'package:flutter/material.dart';
import '../models/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: [
              Container(
                height: 250.0,
                child: Image(
                  image: AssetImage('assets/images/santorini.jpg'),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                bottom: -60,
                child: Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 4.0,
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/user4.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -88,
                child: Text(
                  'Đoàn Duy Cường',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 88.0,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: labels.length,
                padding: EdgeInsets.only(top: 0.0),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      icons[index],
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(labels[index]),
                    onTap: () {},
                  );
                }),
          ),
        ],
      ),
    );
  }
}
