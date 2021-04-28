import 'package:helpme/Screens/register/components/body_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key, @required this.checkcode, @required this.phone})
      : super(key: key);
  final String checkcode;
  final String phone;
  @override
  _AuthScreenState createState() => _AuthScreenState(checkcode, phone);
}

class _AuthScreenState extends State<AuthScreen> {
  _AuthScreenState(
    this.checkcode,
    this.phone,
  );
  String checkcode;
  String phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyAuth(
        checkcode: checkcode,
        phone: phone,
      ),
    );
  }
}
