import 'package:helpme/Screens/Welcome/components/background.dart';
import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/components/rounded_button.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/straintion/right_left.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../register/register_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          "WELCOME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sriracha',
                            fontSize: 30,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "to ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sriracha',
                            fontSize: 30,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Text(
                      "HELP ME!!!!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sriracha',
                        fontSize: 30,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Image.asset(
              "assets/images/help.png",
              width: size.height * 0.45,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedButton(
              text: 'login'.tr().toString(),
              press: () {
                Navigator.push(
                  context,
                  SlideRightRouteRL(
                    page: LoginScreen(),
                  ),
                );
              },
              color: kPrimaryColor,
              textcolor: Colors.white,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            RoundedButton(
              text: 'signup'.tr().toString(),
              press: () {
                Navigator.push(
                  context,
                  SlideRightRouteRL(
                    page: RegisterScreen(),
                  ),
                );
              },
              color: kPrimaryLightColor,
              textcolor: kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }
}
