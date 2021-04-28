import 'package:flutter/material.dart';
import 'package:helpme/constants.dart';

import 'components/body_map.dart';
class ScreenMapPicker extends StatefulWidget {
  @override
  _ScreenMapPickerState createState() => _ScreenMapPickerState();
}

class _ScreenMapPickerState extends State<ScreenMapPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("choose location"),
      ),
      body: BodyMap(),
    );
  }
}
