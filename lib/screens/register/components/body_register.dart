import 'package:helpme/Screens/login/components/form_error.dart';
import 'package:helpme/Screens/login/components/keyboard.dart';
import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/Screens/register/auth_screen.dart';
import 'package:helpme/Screens/register/components/background_regis.dart';
import 'package:helpme/components/box_input.dart';
import 'package:helpme/components/notificationPlugin.dart';
import 'package:helpme/components/rounded_button.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/straintion/left_right.dart';
import 'package:flutter/material.dart';
import 'package:helpme/straintion/load_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'notificationScreens.dart';

class BodyRegis extends StatefulWidget {
  @override
  _BodyRegisState createState() => _BodyRegisState();
}

class _BodyRegisState extends State<BodyRegis> {
  final List<String> errors = [];
  final _formKeyr1 = GlobalKey<FormState>();
  String phone;

  TextEditingController phoneController = TextEditingController();
  Future<void> _phone() async {
    try {
      final response = await http.post(url + "phone", body: {
        "phone": phoneController.text,
      });
      print(phoneController.text);
      ProcessDialog.closeLoadingDialog();

      if (response.statusCode == 201) {
        await notificationPlugin.showNotification(response.body);
        Navigator.push(
          context,
          SlideRightRouteLR(
            page: AuthScreen(
                checkcode: response.body, phone: phoneController.text),
          ),
        );
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Lỗi",
          desc: "Số điện thoại đã được dùng",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 50,
            )
          ],
        ).show();
      }
    } catch (e) {}
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundRegis(
      child: SingleChildScrollView(
        child: Form(
          key: _formKeyr1,
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
              BoxInput(
                input: TextFormField(
                  controller: phoneController,
                  onChanged: (value) {
                    removeError(error: kInvalidPhoneError);
                    if (value.isNotEmpty) {
                      removeError(error: kPhoneNullError);
                    }
                    return null;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      addError(error: kPhoneNullError);
                      return "";
                    } else if (!phoneValidatorRegExp.hasMatch(value)) {
                      addError(error: kInvalidPhoneError);
                      return "";
                    }
                    return null;
                  },
                  onSaved: (newValue) => phone = newValue,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                      size: 20,
                    ),
                    hintText: "Numberphone",
                    border: InputBorder.none,
                  ),
                ),
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
              //         Icons.visib  ility,
              //         color: kPrimaryColor,
              //       ),
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: FormError(errors: errors),
              ),

              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "Next",
                press: () async {
                  if (_formKeyr1.currentState.validate()) {
                    _formKeyr1.currentState.save();
                    // if all are valid then go to success screen
                    KeyboardUtil.hideKeyboard(context);
                    ProcessDialog.showLoadingDialog(context);
                    _phone();
                  }

                  // await notificationPlugin.scheduleNotification();
                  // await notificationPlugin.repeatNotification();
                  // await notificationPlugin.showDailyAtTime();
                  // await notificationPlugin.showWeeklyAtDayTime();
                  // count = await notificationPlugin.getPendingNotificationCount();
                  // print('Count $count');
                  // await notificationPlugin.cancelNotification();
                  // count = await notificationPlugin.getPendingNotificationCount();
                  // print('Count $count');
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
                    SlideRightRouteLR(
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
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {}
}
