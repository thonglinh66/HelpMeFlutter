import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.screenSize,
    @required this.backgroundpath,
  }) : super(key: key);

  final Size screenSize;
  final String backgroundpath;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height / 3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(backgroundpath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
