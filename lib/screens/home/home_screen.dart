import 'package:flutter/material.dart';
import 'package:helpme/Screens/Home/components/body_home.dart';
import 'package:helpme/components/coustom_bottom_nav_bar.dart';
import 'package:helpme/components/enums.dart';
import 'package:helpme/components/size_config.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
