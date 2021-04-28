import 'package:helpme/Screens/register/components/body_auth.dart';
import 'package:flutter/material.dart';

import 'components/body_filldata.dart';

class FillDataScreen extends StatefulWidget {
  FillDataScreen({Key key, @required this.phone}) : super(key: key);
  final String phone;
  @override
  _FillDataState createState() => _FillDataState(phone);
}

class _FillDataState extends State<FillDataScreen> {
  _FillDataState(this.phone);
  String phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyFill(phone: phone),
    );
  }
}
