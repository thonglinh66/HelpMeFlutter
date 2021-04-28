import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpme/Screens/Home/components/section_title.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';

class ButtonSearch extends StatelessWidget {
  const ButtonSearch({
    Key key,
    this.press,
    this.padding,
    this.size,
    this.icon,
  }) : super(key: key);
  final Function press;
  final double size;
  final double padding;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: getProportionateScreenWidth(size),
          width: getProportionateScreenWidth(size),
          child: MaterialButton(
            onPressed: press,
            color: kPrimaryColor,
            child: SvgPicture.asset(
              icon,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(getProportionateScreenWidth(padding)),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }
}
