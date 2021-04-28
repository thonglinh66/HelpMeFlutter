import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xfffccebd);
const kGoogleApiKey = "AIzaSyCX2HNdJSxXZ8ZLjEzGG86cgWTUGlJiars";
const kTextColor = Color(0xFF757575);
const kPrimaryBackground = Color(0xfff9be57);
// Form Error
String parent = r'(0[3|5|7|8|9])+([0-9]{8})$';
final RegExp phoneValidatorRegExp = RegExp(parent);
const String kPhoneNullError = "Please Enter your phone";
const String kInvalidPhoneError = "Please Enter Valid Phone";
const String kPassNullError = "Please Enter your password";
const String kInvalidPasPhoneError = "Phone or password don't correct";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kInvalidPasError = "Passwords don't correct";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

const String url = "https://damp-depths-89624.herokuapp.com/api/phone/";
const String urlImage = "https://damp-depths-89624.herokuapp.com//";
