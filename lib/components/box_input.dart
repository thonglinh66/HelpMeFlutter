import 'package:helpme/constants.dart';
import 'package:flutter/material.dart';

class BoxInput extends StatelessWidget {
  final Widget input;
  const BoxInput({Key key, @required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: input,
    );
  }
}
