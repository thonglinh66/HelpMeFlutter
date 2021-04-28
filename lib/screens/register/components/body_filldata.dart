import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpme/Screens/login/login_screen.dart';
import 'package:helpme/Screens/map_picker/map_picker.dart';
import 'package:helpme/Screens/register/components/background_regis.dart';
import 'package:helpme/components/box_input.dart';
import 'package:helpme/components/rounded_button.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';
import 'package:flutter/material.dart';
import 'package:helpme/model/catologis.dart';
import 'package:helpme/straintion/load_screen.dart';
import 'package:helpme/straintion/right_left.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class BodyFill extends StatefulWidget {
  BodyFill({Key key, @required this.phone}) : super(key: key);
  final String phone;
  @override
  _FillDataState createState() => _FillDataState(phone);
}

class _FillDataState extends State<BodyFill> {
  _FillDataState(this.phone);

  List<String> getDate = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ];
  List<String> getMonth = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  List<String> getYear = <String>[
    '1963',
    '1964',
    '1965',
    '1966',
    '1967',
    '1968',
    '1969',
    '1970',
    '1971',
    '1972',
    '1973',
    '1974',
    '1975',
    '1976',
    '1977',
    '1978',
    '1979',
    '1980',
    '1981',
    '1982',
    '1983',
    '1984',
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022'
  ];
  List<CatologisModelF1> categoriesF3 = [
    CatologisModelF1(
      icon: 'assets/icons/coffee-cup.svg',
      text: 'Cafe',
      type: 1,
    ),
    CatologisModelF1(
      icon: 'assets/icons/camera.svg',
      text: 'Rạp phim',
      type: 2,
    ),
    CatologisModelF1(
      icon: 'assets/icons/amusement-park.svg',
      text: 'Giải trí',
      type: 3,
    ),
    CatologisModelF1(
      icon: 'assets/icons/hospital.svg',
      text: 'Bệnh viện',
      type: 4,
    ),
    CatologisModelF1(
      icon: 'assets/icons/hotel.svg',
      text: 'Khách sạn',
      type: 5,
    ),
    CatologisModelF1(
      icon: 'assets/icons/fuel-station.svg',
      text: 'Trạm xăng',
      type: 6,
    ),
    CatologisModelF1(
      icon: 'assets/icons/shoe-shop.svg',
      text: 'Shop',
      type: 7,
    ),
    CatologisModelF1(
      icon: 'assets/icons/car-repair.svg',
      text: 'Sửa xe',
      type: 8,
    ),
    CatologisModelF1(
      icon: 'assets/icons/dish.svg',
      text: 'Quán ăn',
      type: 9,
    ),
    CatologisModelF1(
      icon: 'assets/icons/cart.svg',
      text: 'Siêu thị',
      type: 10,
    ),
    CatologisModelF1(
      icon: 'assets/icons/Plus Icon.svg',
      text: 'Khác',
      type: 0,
    ),
  ];
  final String phone;
  ProcessDialog processDialog;
  String date = DateTime.now().day.toString();
  bool success = false;
  int _selection = 0;
  bool _checkStore = false;
  double _floatSize = 0;
  double _lng, _lat;
  String results = '';
  @override
  initState() {
    super.initState();
    _selection = 0;
  }

  Future search(lat, long) async {
    try {
      final coordinates = new Coordinates(lat, long);
      var results =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.setState(() {
        this.results = results.first.addressLine.toString();
      });
    } catch (e) {
      this.setState(() {
        this.results = "Error occured: $e";
      });
    }
  }

  selectTime(int timeSelected) {
    setState(() {
      _selection = timeSelected;
    });
  }

  String month = DateTime.now().month.toString();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repass = TextEditingController();
  String year = DateTime.now().year.toString();

  bool _checktype = false;

  CatologisModelF1 selectedUser;
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
            BoxInput(
              input: TextField(
                controller: name,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                  hintText: "Fullname",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            BoxInput(
              input: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            BoxInput(
              input: TextField(
                controller: repass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Repassword",
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: size.width * 0.7,
              height: size.height * 0.05,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: date,
                    iconSize: 24,
                    elevation: 10,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String string) => setState(() => date = string),
                    items: getDate.map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text('$item'),
                        value: item,
                      );
                    }).toList(),
                  ),

                  DropdownButton<String>(
                    value: month,
                    iconSize: 24,
                    elevation: 10,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String string) =>
                        setState(() => month = string),
                    items: getMonth.map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text('$item'),
                        value: item,
                      );
                    }).toList(),
                  ),

                  DropdownButton<String>(
                    value: year,
                    iconSize: 24,
                    elevation: 10,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String string) => setState(() => year = string),
                    items: getYear.map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text('$item'),
                        value: item,
                      );
                    }).toList(),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(right: size.width * 0.1),
                  //   child: DropdownButton<String>(
                  //     value: month,
                  //     iconSize: 24,
                  //     elevation: 16,
                  //     style: TextStyle(color: Colors.deepPurple),
                  //     underline: Container(
                  //       height: 2,
                  //       color: Colors.deepPurpleAccent,
                  //     ),
                  //     onChanged: (String newValue) {
                  //       setState(() {
                  //         date = newValue;
                  //       });
                  //     },
                  //     items: getMonth
                  //         .map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: month,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(60)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: getProportionateScreenWidth(120),
                    height: getProportionateScreenHeight(56),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        setState(() {
                          _selection = 0;
                          _checkStore = false;
                          _floatSize = 0;
                        });
                      },
                      color:
                          _selection == 0 ? kPrimaryColor : kPrimaryLightColor,
                      child: Text(
                        "Customer",
                        style: TextStyle(
                          color: _selection == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(120),
                    height: getProportionateScreenHeight(56),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        setState(() {
                          _selection = 1;
                          _checkStore = true;
                          _floatSize = 0;
                        });
                      },
                      color:
                          _selection == 0 ? kPrimaryLightColor : kPrimaryColor,
                      child: Text(
                        "Store",
                        style: TextStyle(
                          color: _selection == 0 ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _checkStore
                ? Column(
                    children: [
                      Container(
                        width: size.width * 0.7,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: InkWell(
                          onTap: () async {
                            LatLng location = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenMapPicker()),
                            );
                            if (location != null) {
                              setState(() {
                                _lat = location.latitude;
                                _lng = location.longitude;
                                search(_lat, _lng);
                              });
                            }
                          },
                          child: Container(
                            width: size.width * 0.7,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                    width: getProportionateScreenWidth(20)),
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: Text(
                                    _lat == null
                                        ? "Click Icon to Select Location"
                                        : results,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.7,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Container(
                          width: size.width * 0.7,
                          child: DropdownButton<CatologisModelF1>(
                            hint: Text("Select item"),
                            value: selectedUser,
                            onChanged: (CatologisModelF1 value) {
                              setState(() {
                                selectedUser = value;
                                if (selectedUser.type == 0) {
                                  _checktype = true;
                                } else {
                                  _checktype = false;
                                }
                              });
                            },
                            items: categoriesF3.map((CatologisModelF1 user) {
                              return DropdownMenuItem<CatologisModelF1>(
                                value: user,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenWidth(15)),
                                      height: getProportionateScreenWidth(55),
                                      width: getProportionateScreenWidth(55),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SvgPicture.asset(user.icon),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(80),
                                    ),
                                    Text(
                                      user.text,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: getProportionateScreenHeight(50),
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
            SizedBox(height: size.height * _floatSize),
            RoundedButton(
              text: "Next",
              press: () async {
                checkLogin();
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
            ),
          ],
        ),
      ),
    );
  }

  checkLogin() {
    if (name.text == "" || password.text == "" || repass.text == "") {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi",
        desc: "Vui lòng điền đủ thông tin",
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
    } else {
      if (password.text != repass.text) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Lỗi",
          desc: "Mật khẩu không trùng khơp",
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
      } else {
        if (_selection == 1) {
          if (results == null || _lat == null || _lng == null) {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Lỗi",
              desc: "Vui lòng chọn địa điểm cửa hàng",
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
          } else if (selectedUser == null) {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Lỗi",
              desc: "Vui lòng chọn loại cửa hàng",
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
          } else {
            ProcessDialog.showLoadingDialog(context);
            downloadJsonUser();
          }
        } else {
          ProcessDialog.showLoadingDialog(context);
          downloadJsonUser();
        }
      }
    }
  }

  Future downloadJsonUser() async {
    final jsonEndpoint = url + "register";
    print(_selection);
    print({
      "username": phone,
      "password": password.text,
      "type": json.encode(_selection),
      "name": name.text,
      "birth": year.toString() + "-" + month.toString() + "-" + date.toString(),
      "address": "results",
      "lat": "null",
      "long": "null",
      "typeSv": "3"
    });
    final response = await http.post(jsonEndpoint, body: {
      "username": phone,
      "password": password.text,
      "type": json.encode(_selection),
      "name": name.text,
      "birth": year.toString() + "-" + month.toString() + "-" + date.toString(),
      "address": results == null ? "null" : results,
      "lat": _lat == null ? "null" : _lat.toString(),
      "long": _lng == null ? "null" : _lng.toString(),
      "typeSv": selectedUser == null ? "null" : selectedUser.type.toString(),
    });
    ProcessDialog.closeLoadingDialog();

    print(response.body);
    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Thành công",
        desc: "Tạo tài khoản thành công",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.push(
              context,
              SlideRightRouteRL(
                page: LoginScreen(),
              ),
            ),
            width: 50,
          )
        ],
      ).show();
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }
}
