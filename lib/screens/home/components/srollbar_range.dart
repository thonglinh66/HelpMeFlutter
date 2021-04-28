import 'package:flutter/material.dart';
import 'package:helpme/Screens/Home/components/body_home.dart';
import 'package:helpme/Screens/Home/components/section_title.dart';
import 'package:helpme/components/size_config.dart';
import 'package:horizontal_picker/horizontal_picker.dart';

import '../../../constants.dart';

class SrollBarRange extends StatefulWidget {
  const SrollBarRange({
    Key key,
  }) : super(key: key);

  @override
  _SrollBarRangeState createState() => _SrollBarRangeState();
}

typedef void RangeCallback(double range);

class _SrollBarRangeState extends State<SrollBarRange> {
  RangeCallback range;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20.0),
          right: getProportionateScreenWidth(20.0)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(20)),
            child: SectionTitle(title: "Khoảng cách", press: () {}),
          ),
          Container(
            width: getProportionateScreenWidth(350),
            height: getProportionateScreenHeight(120),
            child: HorizantalPicker(
              minValue: 50,
              maxValue: 3000,
              divisions: 59,
              suffix: "m",
              showCursor: false,
              backgroundColor: Colors.grey.shade900,
              activeItemTextColor: Colors.white,
              passiveItemsTextColor: kPrimaryColor,
              onChanged: (value) {
                setState(() {
                  HomeBody.of(context).range = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
