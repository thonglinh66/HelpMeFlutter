import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required String bio,
  })  : _bio = bio,
        super(key: key);

  final String _bio;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          _bio,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Spectral',
            fontWeight:
                FontWeight.w400, //try changing weight to w500 if not thin
            fontStyle: FontStyle.italic,
            color: Color(0xFF799497),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
