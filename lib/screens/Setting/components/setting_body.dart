import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/Screens/Home/components/home_header.dart';
import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/straintion/bottom_top.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class SettingBody extends StatefulWidget {
  @override
  _SettingBodyState createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("lang".tr().toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text("Việt Nam"),
                        ),
                        Image.asset(
                          "assets/images/vn.png",
                          width: 50,
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        EasyLocalization.of(context).locale =
                            Locale('vi', 'VN');
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text("English"),
                        ),
                        Image.asset(
                          "assets/images/en.png",
                          width: 50,
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        EasyLocalization.of(context).locale =
                            Locale('en', 'EN');
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          HomeHeader(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Text(
                  "general".tr().toString(),
                  style: TextStyle(
                      fontSize: 26,
                      color: kTextColor,
                      fontWeight: FontWeight.bold),
                ),
                Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.language,
                          color: Colors.green,
                        ),
                        title: Text("lang".tr().toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("VN"),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        onTap: () async {
                          _showChoiceDialog(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: Text("logout".tr().toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[Icon(Icons.arrow_forward_ios)],
                        ),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs?.setString("isLoggedIn", "");
                          prefs?.setString("username", "");
                          prefs?.setString("type", "");

                          Navigator.push(
                              context, SildeRouteBT(page: LoginScreen()));
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "system".tr().toString(),
                  style: TextStyle(
                      fontSize: 26,
                      color: kTextColor,
                      fontWeight: FontWeight.bold),
                ),
                Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.phone_android,
                          color: kPrimaryColor,
                        ),
                        title: Text("version".tr().toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("1.0.0"),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.file_upload,
                          color: Colors.orange,
                        ),
                        title: Text("upgrade".tr().toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
