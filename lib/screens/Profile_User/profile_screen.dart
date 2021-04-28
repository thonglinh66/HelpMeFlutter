import 'package:flutter/material.dart';
import 'package:helpme/Screens/List/components/list_body.dart';
import 'package:helpme/components/coustom_bottom_nav_bar.dart';
import 'package:helpme/components/enums.dart';

import 'components/profile_body.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfilePage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
