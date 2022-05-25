import 'package:flutter/material.dart';
import '/screens/homeScreen.dart';

class Success extends StatefulWidget {
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/payment_success.png'),
            height: 200.0,
          ),
          SizedBox(height: 20.0),
          SubTitle(subTitleText: 'Thanh toán thành công'),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String subTitleText;
  SubTitle({
    this.subTitleText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitleText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
