import 'package:flutter/material.dart';

import 'components/body_success.dart';

class SuccessScreen extends StatefulWidget {
  SuccessScreen({
    @required this.type,
    Key key,
  }) : super(key: key);
  final int type;
  @override
  _SuccessScreenState createState() => _SuccessScreenState(type);
}

class _SuccessScreenState extends State<SuccessScreen> {
  int type;
  _SuccessScreenState(this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_success.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BodySuccess(type: type),
      ),
    );
  }
}
