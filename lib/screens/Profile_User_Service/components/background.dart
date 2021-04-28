import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/Screens/Profile_User/profile_screen.dart';
import 'package:helpme/Screens/Profile_User_Service/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class Background extends StatefulWidget {
  const Background({
    Key key,
    @required this.backgroundpath,
    @required this.screenSize,
  }) : super(key: key);
  final Size screenSize;

  final String backgroundpath;
  @override
  _BackgroundState createState() =>
      _BackgroundState(backgroundpath, screenSize);
}

class _BackgroundState extends State<Background> {
  _BackgroundState(this.backgroundpath, this.screenSize);
  Size screenSize;
  String backgroundpath;
  String base64Image;
  final picker = ImagePicker();
  File imageFile;
  Future _openGallary(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        Navigator.of(context).pop();

        uploadBackground();
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

        uploadBackground();

        Navigator.of(context).pop();
      } else {
        print('No image selected.');
        Navigator.of(context).pop();
      }
    });
  }

  Future uploadBackground() async {
    final uri = Uri.parse(url + "updatebackgroundSer");
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
          builder: (BuildContext context) => UserProfileScreenService(),
        ),
      );
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
    return InkWell(
      onLongPress: () => _showChoiceDialog(context),
      child: Container(
        height: screenSize.height / 3,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(backgroundpath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
