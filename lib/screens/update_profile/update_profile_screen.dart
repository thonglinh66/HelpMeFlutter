import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:helpme/Screens/Profile_User/profile_screen.dart';
import 'package:helpme/Screens/login/components/form_error.dart';
import 'package:helpme/components/default_button.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/user.dart';
import 'package:helpme/straintion/top_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({
    @required this.usermodelFuture,
    @required this.userModel,
    Key key,
  }) : super(key: key);
  final UserModel userModel;
  final Future<UserModel> usermodelFuture;
  @override
  _UpdateProfileScreenState createState() =>
      _UpdateProfileScreenState(userModel, usermodelFuture);
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  _UpdateProfileScreenState(this.userModel, this.usermodelFuture);
  Future<UserModel> usermodelFuture;

  UserModel userModel;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String dicript;
  DateTime birth;
  TextEditingController _name = TextEditingController();
  TextEditingController _dicript = TextEditingController();

  int id = 1;

  @override
  void initState() {
    super.initState();
    _name.text = userModel.name;
    _dicript.text = userModel.decript;
    birth = DateTime.parse(userModel.birth);
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

  BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          scaffoldContext = context;
          return SafeArea(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            SlideRightRoute(page: UserProfileScreen()),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(100),
                        ),
                        child: Text(
                          "updateprofile".tr().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Text(
                            "updateTitle".tr().toString(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            "pleasefull".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    buildFirstNameFormField(userModel.name),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    buildDiscriptFormField(userModel.decript),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    FlatButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1900, 3, 5),
                                            maxTime: DateTime.now(),
                                            onChanged: (date) {
                                          birth = date;
                                        }, onConfirm: (date) {
                                          birth = date;
                                        },
                                            currentTime: birth,
                                            locale: LocaleType.vi);
                                      },
                                      child: Text(
                                        'choosedatebirth'.tr().toString(),
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    FormError(errors: errors),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    DefaultButton(
                                      text: "update".tr().toString(),
                                      press: () {
                                        if (_formKey.currentState.validate()) {
                                          // saveprofile();
                                          setState(() {});
                                        }
                                        saveprofile();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          Text(
                            "",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future saveprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs?.getString("username");
    try {
      final response = await http.post(url + "saveprofile", body: {
        "name": _name.text,
        "dicript": _dicript.text,
        "birth": birth.toString(),
        "username": username,
      });
      print(response.body);
      if (response.body == "1") {
        final snackBar = SnackBar(
          content: Text('successupdate'.tr().toString()),
          duration: Duration(seconds: 2),
          action: new SnackBarAction(
            label: 'success'.tr().toString(),
            onPressed: () {
              // Some code to undo the change!
            },
          ),
        );
        Scaffold.of(scaffoldContext).showSnackBar(snackBar);
        setState(() {
          usermodelFuture = downloadJsonUser();
          usermodelFuture.then((result) {
            setState(() {
              userModel = result;
            });
          });
        });
      } else {
        final snackBar = SnackBar(
          content: Text('failupdate'.tr().toString()),
          duration: Duration(seconds: 2),
          action: new SnackBarAction(
            label: 'fail'.tr().toString(),
            onPressed: () {
              // Some code to undo the change!
            },
          ),
        );
        Scaffold.of(scaffoldContext).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  TextFormField buildDiscriptFormField(String address) {
    return TextFormField(
      controller: _dicript,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "introduce".tr().toString(),
        // hintText: address,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.description),
      ),
    );
  }

  TextFormField buildFirstNameFormField(String name) {
    return TextFormField(
      controller: _name,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "fullname".tr().toString(),
        // hintText: name,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
      ),
    );
  }
}
