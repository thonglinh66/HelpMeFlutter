import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:helpme/Screens/Profile_User_Service/profile_screen.dart';
import 'package:helpme/Screens/login/components/form_error.dart';
import 'package:helpme/components/default_button.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/straintion/top_bottom.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';

class UpdateProfileScreenService extends StatefulWidget {
  UpdateProfileScreenService({
    @required this.serviceModel,
    Key key,
  }) : super(key: key);
  final ServiceModel serviceModel;
  @override
  _UpdateProfileScreenServiceState createState() =>
      _UpdateProfileScreenServiceState(serviceModel);
}

class _UpdateProfileScreenServiceState
    extends State<UpdateProfileScreenService> {
  _UpdateProfileScreenServiceState(this.serviceModel);

  ServiceModel serviceModel;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String dicript;
  DateTime birth;
  TextEditingController _name = TextEditingController();
  TextEditingController _dicript = TextEditingController();
  TextEditingController _logan = TextEditingController();
  DateTime timeopen;
  DateTime timeclose;
  int id = 1;
  TimeOfDay selectedTime;
  @override
  void initState() {
    super.initState();
    _name.text = serviceModel.name;
    _dicript.text =
        serviceModel.decription == null ? '' : serviceModel.decription;
    _logan.text = serviceModel.brand == null ? '' : serviceModel.brand;
    birth = DateTime.parse(serviceModel.birthDay);
    timeopen = serviceModel.open.toString() == null
        ? DateFormat('HH:mm').parse('00:00')
        : DateFormat('HH:mm').parse(serviceModel.open);
    timeclose = serviceModel.close.toString() == null
        ? DateFormat('HH:mm').parse('24:00')
        : DateFormat('HH:mm').parse(serviceModel.close);
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
                            SlideRightRoute(page: UserProfileScreenService()),
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
                                    buildFirstNameFormField(serviceModel.name),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    buildDiscriptFormField(
                                        serviceModel.decription),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    buildLoganFormField(serviceModel.brand),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
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
                                        'choosedatecreate'
                                            .tr()
                                            .toString(),
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlatButton(
                                          onPressed: () {
                                            DatePicker.showTimePicker(context,
                                                showTitleActions: true,
                                                onChanged: (date) {
                                              timeopen = date;
                                            }, onConfirm: (date) {
                                              timeopen = date;
                                            },
                                                currentTime: timeopen,
                                                locale: LocaleType.vi);
                                          },
                                          child: Text(
                                            'timeopen'.tr().toString(),
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            DatePicker.showTimePicker(context,
                                                showTitleActions: true,
                                                onChanged: (date) {
                                              timeclose = date;
                                            }, onConfirm: (date) {
                                              timeclose = date;
                                            },
                                                currentTime: timeclose,
                                                locale: LocaleType.vi);
                                          },
                                          child: Text(
                                            'timeclose'.tr().toString(),
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
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
      final response = await http.post(url + "saveprofileservice", body: {
        "name": _name.text,
        "dicript": _dicript.text,
        "birth": DateFormat('dd-mm-yyyy').format(birth).toString(),
        "brand": _logan.text,
        "open": DateFormat('HH:mm').format(timeopen).toString(),
        "close": DateFormat('HH:mm').format(timeclose).toString(),
        "username": username,
      });

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
      } else {
        final snackBar = SnackBar(
          content: Text('failupdate'.tr().toString()),
          duration: Duration(seconds: 2),
          action: new SnackBarAction(
            label: 'success'.tr().toString(),
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

  TextFormField buildLoganFormField(String address) {
    return TextFormField(
      controller: _logan,
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
        labelText: "logan".tr().toString(),
        // hintText: address,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.speaker),
      ),
    );
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
