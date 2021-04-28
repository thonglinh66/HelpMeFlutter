import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpme/Screens/Home/components/button_search.dart';
import 'package:helpme/Screens/Profile_User/components/container.dart';
import 'package:helpme/Screens/update_profile/update_profile_screen.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/user.dart';
import 'package:helpme/straintion/bottom_top.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import 'Unline.dart';
import 'background.dart';
import 'decription.dart';
import 'informatio.dart';
import 'logo.dart';
import 'name.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final String _fullName = "Nick Frost";
  final String _status = "Software Developer";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  Future<UserModel> usermodelFuture;

  UserModel userModel;

  void moveToSecondPage() {
    Navigator.push(
      context,
      SildeRouteBT(
        page: UpdateProfileScreen(
          usermodelFuture: usermodelFuture,
          userModel: userModel,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usermodelFuture = downloadJsonUser();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: usermodelFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userModel = snapshot.data;
            return SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Background(
                    screenSize: screenSize,
                    backgroundpath: userModel.background,
                  ),
                  SafeArea(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: screenSize.height / 6.4),
                        Logo(logopath: userModel.image),
                        Name(fullName: userModel.name),
                        ContainerCP(status: userModel.decript),
                        Unline(screenSize: screenSize),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(50)),
                          child: Container(
                            width: getProportionateScreenWidth(350),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.orange[300],
                                      size: 25,
                                    ),
                                    title: Text(
                                      "Họ Tên",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          width:
                                              getProportionateScreenWidth(150),
                                          child: Text(
                                            userModel.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.cake,
                                      color: Colors.orange[300],
                                      size: 25,
                                    ),
                                    title: Text(
                                      "Ngày sinh",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          width:
                                              getProportionateScreenWidth(150),
                                          child: Text(
                                            DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(userModel.birth),
                                            ),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            moveToSecondPage();
                          },
                          child: Container(
                            width: getProportionateScreenWidth(200),
                            height: getProportionateScreenHeight(50),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Cập nhập thông tin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // GetContent(selectedIndex, serviceModel),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
