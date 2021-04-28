import 'package:helpme/Screens/Home/home_screen.dart';
import 'package:helpme/Screens/login/components/login_form.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';
import 'package:flutter/material.dart';
import '../components/background_login.dart';

class BodyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundLogin(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(
                fontFamily: 'Sriracha',
                fontSize: 30,
                color: kPrimaryColor,
              ),
            ),
            Image.asset(
              "assets/images/old.png",
              width: size.width * 0.6,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(40)),
              child: SignForm(),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
