import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/Screens/register/components/background_regis.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:helpme/Screens/register/fill_data.dart';
import 'package:helpme/components/notificationPlugin.dart';
import 'package:helpme/components/rounded_button.dart';
import 'package:helpme/constants.dart';
import 'package:flutter/material.dart';
import 'package:helpme/straintion/right_left.dart';

class BodyAuth extends StatefulWidget {
  BodyAuth({Key key, @required this.checkcode, @required this.phone})
      : super(key: key);
  final String checkcode;
  final String phone;
  @override
  _BodyAuthState createState() => _BodyAuthState(checkcode, phone);
}

class _BodyAuthState extends State<BodyAuth> {
  _BodyAuthState(
    this.checkcode,
    this.phone,
  );
  String _code;
  String phone;
  String checkcode;
  bool _onEditing;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(checkcode);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BackgroundRegis(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign Up",
              style: TextStyle(
                fontFamily: 'Sriracha',
                fontSize: 30,
                color: kPrimaryColor,
              ),
            ),
            Image.asset(
              "assets/images/child.png",
              width: size.width * 0.2,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            VerificationCode(
              textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
              underlineColor: Colors.amber,
              keyboardType: TextInputType.number,
              length: 4,

              // clearAll is NOT required, you can delete it
              // takes any widget, so you can implement your design
              clearAll: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'clear all',
                  style: TextStyle(
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                      color: Colors.blue[700]),
                ),
              ),

              onCompleted: (String value) {
                setState(() {
                  _code = value;
                });
              },
              onEditing: (bool value) {
                setState(() {
                  _onEditing = value;
                });
              },
            ),
            Text(
              getText(),
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red[900],
                  fontFamily: 'Sriracha'),
            ),
            // BoxInput(
            //   input: TextField(
            //     obscureText: true,
            //     decoration: InputDecoration(
            //       hintText: "Password",
            //       icon: Icon(
            //         Icons.lock,
            //         color: kPrimaryColor,
            //       ),
            //       suffixIcon: Icon(
            //         Icons.visibility,
            //         color: kPrimaryColor,
            //       ),
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
            // BoxInput(
            //   input: TextField(
            //     obscureText: true,
            //     decoration: InputDecoration(
            //       hintText: "Repassword",
            //       icon: Icon(
            //         Icons.lock,
            //         color: kPrimaryColor,
            //       ),
            //       suffixIcon: Icon(
            //         Icons.visibility,
            //         color: kPrimaryColor,
            //       ),
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "Next",
              press: () {
                check_success();
              },
              color: kPrimaryColor,
              textcolor: Colors.white,
            ),
            Text(
              "If you really has account please",
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
                    page: LoginScreen(),
                  ),
                );
              },
              child: Text(
                "Login!!",
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
        ),
      ),
    );
  }

  void check_success() {
    print(_code);
    if (_code == checkcode) {
      Navigator.push(
        context,
        SlideRightRouteRL(
          page: FillDataScreen(phone: phone),
        ),
      );
    } else {
      setState(() {
        _code = "You code don't correct";
      });
    }
  }

  String getText() {
    if (_code == null) {
      return 'None';
    } else {
      return _code;
    }
  }
}
