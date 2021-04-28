import 'package:helpme/Screens/Home/home_screen.dart';
import 'package:helpme/Screens/Welcome/components/body.dart';
import 'package:flutter/material.dart';
import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/straintion/bottom_top.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget bodyScreen = Container();
  _WelcomeScreenState() {
    getWidget().then(
      (val) => setState(
        () {
          bodyScreen = val;
        },
      ),
    );
  }

  Future<Widget> getWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString('isLoggedIn') ?? '999';
    // 5s over, navigate to a new page
    if (status == '0') {
      return HomeScreen();
    } else if (status == '1') {
      return HomeScreen();
    } else {
      return Scaffold(
        body: Body(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return bodyScreen;
  }
}
