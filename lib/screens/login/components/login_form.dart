import 'package:flutter/material.dart';
import 'package:helpme/Screens/Home/home_screen.dart';
import 'package:helpme/Screens/forgot_password/forgot_password_screen.dart';
import 'package:helpme/Screens/login/components/no_account_text.dart';
import 'package:helpme/Screens/login_success/login_sucess.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/straintion/left_right.dart';
import 'package:helpme/straintion/load_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import 'custom_surfix_icon.dart';
import 'form_error.dart';
import 'keyboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String phone;
  String password;
  bool remember = false;
  bool isLogging = false;
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final List<String> errors = [];

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

  Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(url + "login", body: {
        "username": userController.text,
        "password": passController.text,
      });

      if (response.body != "999") {
        if (remember) {
          prefs?.setString("isLoggedIn", response.body);
        }

        prefs?.setString("username", userController.text);
        prefs?.setString("type", response.body);
        print(response.body);
        ProcessDialog.closeLoadingDialog();

        Navigator.push(
          context,
          SlideRightRouteLR(
            page: SuccessScreen(
              type: int.parse(
                response.body,
              ),
            ),
          ),
        );
      } else {
        ProcessDialog.closeLoadingDialog();
        passController.clear();
        userController.clear();
        addError(error: kInvalidPasPhoneError);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Login",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                ProcessDialog.showLoadingDialog(context);
                _login();
              }
            },
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          NoAccountText()
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passController,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        removeError(error: kInvalidPasError);
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
          removeError(error: kShortPassError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }

        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: userController,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        removeError(error: kInvalidPhoneError);
        if (value.isNotEmpty) {
          removeError(error: kPhoneNullError);
        } else if (phoneValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPhoneError);
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
      decoration: InputDecoration(
        labelText: "Phone",
        hintText: "Enter your phone",
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
