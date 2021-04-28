import 'package:flutter/material.dart';
import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/components/coustom_bottom_nav_bar.dart';
import 'package:helpme/components/enums.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/straintion/bottom_top.dart';

import 'components/setting_body.dart';

class SettingScreen extends StatefulWidget {
  @override
  _MenuOptionsScreenState createState() => _MenuOptionsScreenState();
}

class _MenuOptionsScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingBody(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.setting),
    );
  }
}
