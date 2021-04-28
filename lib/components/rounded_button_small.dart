import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color, textcolor;
  final String text;
  final Function press;
  const RoundedButton({
    Key key,
    this.color,
    this.textcolor,
    this.text,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.6,
      height: size.height * 0.07,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: FlatButton(
          onPressed: press,
          color: color,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              text,
              style: TextStyle(color: textcolor, fontFamily: 'Sriracha'),
            ),
          ),
        ),
      ),
    );
  }
}
