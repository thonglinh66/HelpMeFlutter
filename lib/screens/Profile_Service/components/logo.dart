import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key key, @required logopath})
      : logopath = logopath,
        super(key: key);
  final String logopath;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(logopath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 5.0,
          ),
        ),
      ),
    );
  }
}
