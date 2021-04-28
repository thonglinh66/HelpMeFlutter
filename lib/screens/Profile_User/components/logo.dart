import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/Screens/Profile_User/profile_screen.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/user.dart';
import 'package:helpme/straintion/load_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/generated/i18n.dart';
import 'package:helpme/components/size_config.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class Logo extends StatefulWidget {
  const Logo({
    Key key,
    @required this.logopath,
  }) : super(key: key);

  final String logopath;
  @override
  _LogoState createState() => _LogoState(logopath);
}

class _LogoState extends State<Logo> {
  _LogoState(this.logopath);
  String logopath;

  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  String base64Image;
  final picker = ImagePicker();
  File imageFile;
  Future _openGallary(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        Navigator.of(context).pop();

        uploadImage();
      } else {
        print('No image selected.');
        Navigator.of(context).pop();
      }
    });
  }

  Future _openCamera(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.camera);

    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);

        uploadImage();

        Navigator.of(context).pop();
      } else {
        print('No image selected.');
        Navigator.of(context).pop();
      }
    });
  }

  Future uploadBackground() async {
    final uri = Uri.parse(url + "updatebackground");
    var request = http.MultipartRequest('POST', uri);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    request.fields['username'] = prefs?.getString("username");
    var pic = await http.MultipartFile.fromPath("image", imageFile.path);
    request.files.add(pic);

    var response = await request.send();
    print(http.Response.fromStream(response));
    // (body.body);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => UserProfileScreen()));
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: Row(
                children: <Widget>[
                  Text("Thành Công"),
                  Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: Row(
                children: <Widget>[
                  Text("Thất bại"),
                  Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            );
          });
    }
  }

  Future uploadImage() async {
    final uri = Uri.parse(url + "updateimage");
    var request = http.MultipartRequest('POST', uri);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    request.fields['username'] = prefs?.getString("username");
    var pic = await http.MultipartFile.fromPath("image", imageFile.path);
    request.files.add(pic);

    var response = await request.send();
    print(http.Response.fromStream(response));
    // (body.body);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => UserProfileScreen()));
      Alert(
        context: context,
        type: AlertType.success,
        title: "Thành công",
        desc: "Cập nhập ảnh thành công",
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
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       Future.delayed(Duration(seconds: 3), () {
      //         Navigator.of(context).pop(true);
      //       });
      //       return AlertDialog(
      //         content: Row(
      //           children: <Widget>[
      //             Text("Thành Công"),
      //             Icon(Icons.check_circle, color: Colors.green),
      //           ],
      //         ),
      //       );
      //     });
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi",
        desc: "Cập nhập ảnh thất bại",
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
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       Future.delayed(Duration(seconds: 3), () {
      //         Navigator.of(context).pop(true);
      //       });
      //       return AlertDialog(
      //         content: Row(
      //           children: <Widget>[
      //             Text("Thất bại"),
      //             Icon(Icons.check_circle, color: Colors.green),
      //           ],
      //         ),
      //       );
      //     });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chọn phương thức"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    child: Text("Thư viện"),
                    onTap: () {
                      _openGallary(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    child: Text("Máy ảnh"),
                    onTap: () {
                      _openCamera(context);
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
    return Center(
      child: Stack(
        children: [
          Container(
            width: getProportionateScreenHeight(140),
            height: getProportionateScreenHeight(140),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(logopath),
                fit: BoxFit.cover,
              ),
              borderRadius:
                  BorderRadius.circular(getProportionateScreenHeight(80.0)),
              border: Border.all(
                color: Colors.white,
                width: getProportionateScreenHeight(5.0),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                _showChoiceDialog(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: AssetImage('assets/images/camera.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
