import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpme/Screens/Home/home_screen.dart';
import 'package:helpme/Screens/List/list_search.dart';
import 'package:helpme/Screens/Profile_Service/components/profile_body.dart';
import 'package:helpme/Screens/Profile_Service/profile_screen.dart';
import 'package:helpme/Screens/Profile_User/profile_screen.dart';
import 'package:helpme/Screens/Profile_User_Service/components/profile_body.dart';
import 'package:helpme/Screens/Profile_User_Service/profile_screen.dart';
import 'package:helpme/Screens/Setting/setting_screen.dart';
import 'package:helpme/components/enums.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFF333030).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/home.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                iconSize: 11,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/list.svg",
                  color: MenuState.list == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                iconSize: 11,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListScreens()),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/manager.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                iconSize: 11,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var status = prefs.getString('type');
                  print(status);
                  if (status == '0') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen()),
                    );
                  } else if (status == '1') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreenService()),
                    );
                  }
                },
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/settings.svg",
                    color: MenuState.setting == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  iconSize: 11,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingScreen()),
                    );
                  }),
            ],
          )),
    );
  }
}
