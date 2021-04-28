import 'package:flutter/material.dart';

class Name extends StatelessWidget {
  const Name({
    Key key,
    @required String fullName,
  })  : _fullName = fullName,
        super(key: key);

  final String _fullName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _fullName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.black,
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
