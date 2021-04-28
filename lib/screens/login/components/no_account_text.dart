import 'package:flutter/material.dart';
import 'package:helpme/Screens/register/register_screen.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/straintion/right_left.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "If you hasn't account please",
          style: TextStyle(
            fontFamily: 'Sriracha',
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              SlideRightRouteRL(
                page: RegisterScreen(),
              ),
            );
          },
          child: Text(
            "Create Account!!",
            style: TextStyle(
              fontFamily: 'Sriracha',
              fontSize: 12,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
