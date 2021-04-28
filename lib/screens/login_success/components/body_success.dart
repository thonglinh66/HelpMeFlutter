import 'package:flutter/material.dart';
import 'package:helpme/Screens/Home/home_screen.dart';
import 'package:helpme/components/rounded_button_small.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/model/servicelogin.dart';
import 'package:helpme/model/user.dart';
import 'package:helpme/straintion/left_right.dart';

class BodySuccess extends StatefulWidget {
  BodySuccess({
    @required this.type,
    Key key,
  }) : super(key: key);
  final int type;
  @override
  _BodySuccessState createState() => _BodySuccessState(type);
}

class _BodySuccessState extends State<BodySuccess> {
  int type;
  _BodySuccessState(this.type);
  Future<UserModel> usermodel;
  Future<ServiceModel> serviceModelFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (type == 0) {
      usermodel = downloadJsonUser();
    } else {
      serviceModelFuture = downloadJsonUserService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(50),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: getProportionateScreenHeight(150),
          ),
          Center(
              child: type == 0
                  ? FutureBuilder<UserModel>(
                      future: usermodel,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            width: 170.0,
                            height: 170.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data.image),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(80.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    )
                  : FutureBuilder<ServiceModel>(
                      future: serviceModelFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            width: 170.0,
                            height: 170.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data.image,
                                    scale: 0.1),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(80.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    )),
          SizedBox(
            height: getProportionateScreenHeight(80),
          ),
          Text(
            'Đăng nhập thành công',
            style: TextStyle(
              fontFamily: 'Sriracha',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(150),
          ),
          RoundedButton(
            color: kPrimaryBackground,
            text: 'Tiếp tục',
            press: () {
              if (type == 0) {
                Navigator.push(
                  context,
                  SlideRightRouteLR(
                    page: HomeScreen(),
                  ),
                );
              }
              if (type == 1) {
                Navigator.push(
                  context,
                  SlideRightRouteLR(
                    page: HomeScreen(),
                  ),
                );
              }
            },
            textcolor: kTextColor,
          ),
        ],
      ),
    );
  }
}
