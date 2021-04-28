import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/Screens/Profile_User/components/container.dart';
import 'package:helpme/Screens/update_profile_service/update_profile_screen_service.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/model/comment.dart';
import 'package:helpme/model/post.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/post/post_screens.dart';
import 'package:helpme/straintion/bottom_top.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../profile_screen.dart';
import 'Unline.dart';
import 'background.dart';
import 'decription.dart';
import 'informatio.dart';
import 'logo.dart';
import 'name.dart';

class UserProfilePageService extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePageService> {
  Future<ServiceModel> serviceModelFuture;
  Future<List<CommentModel>> commentModel;
  Future<int> cmntPostsid;
  Future<List<PostModel>> postModelFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceModelFuture = downloadJsonUserService();

    if (selectedIndex == null) {
      selectedIndex = 0;
    }
  }

  Future<int> downloadJsonCmnts(int id) async {
    final jsonEndpoint = url + "countCmntPost";
    var idpost = json.encode(id);
    final response = await http.post(jsonEndpoint, body: {
      "postid": idpost,
    });
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  TextEditingController titleController = TextEditingController();
  String base64Image;
  final picker = ImagePicker();
  File imageFile;
  Future _openGallary(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        Navigator.of(context).pop();
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

        Navigator.of(context).pop();
      } else {
        print('No image selected.');
        Navigator.of(context).pop();
      }
    });
  }

  Future uploadImage(context) async {
    final uri = Uri.parse(url + "updateimageSer");
    var request = http.MultipartRequest('POST', uri);
    request.fields['username'] = await FlutterSession().get("username");
    var pic = await http.MultipartFile.fromPath("image", imageFile.path);
    request.files.add(pic);

    var response = await request.send();
    print(http.Response.fromStream(response));
    // (body.body);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => UserProfileScreenService()));
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

  Future uploadPost(context, ServiceModel serviceModel) async {
    var title = titleController.text == null ? "" : titleController.text;
    if (imageFile == null) {
      final jsonEndpoint = url + "uploadpost";
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var user = prefs?.getString("username");

      final response = await http.post(jsonEndpoint, body: {
        "username": user,
        "title": title,
      });
      print(response.body);
      if (response.body == '200') {
        print('success');

        setState(() {
          postModelFuture = downloadJSONPost(serviceModel.username);
        });
        Navigator.pop(context);
      } else
        throw Exception(
            'We were not able to successfully download the json data.');
    } else {
      final uri = Uri.parse(url + "uploadpost");
      var request = http.MultipartRequest('POST', uri);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      request.fields['title'] = title;
      request.fields['username'] = prefs?.getString("username");
      var pic = await http.MultipartFile.fromPath("image", imageFile.path);
      request.files.add(pic);

      var response = await request.send();

      if (response.statusCode == 200) {
        print('success');

        setState(() {
          postModelFuture = downloadJSONPost(serviceModel.username);
        });
        Navigator.pop(context);
        print('success');
      }
    }

    // (body.body);
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

  List<String> categories = [
    "Thông tin",
    "Bài đăng",
    "Bình luận",
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<ServiceModel>(
        future: serviceModelFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ServiceModel serviceModel = snapshot.data;
            postModelFuture = downloadJSONPost(serviceModel.username);
            commentModel = downloadJSONComment(serviceModel.username);
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Background(
                          screenSize: screenSize,
                          backgroundpath: serviceModel.background),
                      SafeArea(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: screenSize.height / 6.4),
                            Logo(logopath: serviceModel.image),
                            Name(fullName: serviceModel.name),
                            ContainerCP(status: serviceModel.brand),
                            Information(
                              rate: double.parse(serviceModel.rate),
                              countCmnt: serviceModel.countCmt,
                              countPost: serviceModel.countPost,
                            ),
                            Description(bio: serviceModel.decription),
                            Unline(screenSize: screenSize),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(20),
                              ),
                              child: SizedBox(
                                height: getProportionateScreenHeight(25), // 35
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenHeight(7),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: getProportionateScreenHeight(
                                                5)),
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenHeight(
                                                  30), //20
                                        ),
                                        decoration: BoxDecoration(
                                            color: selectedIndex == index
                                                ? Color(0xFFEFF3EE)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              getProportionateScreenHeight(
                                                  10), // 16
                                            )),
                                        child: Text(
                                          categories[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: selectedIndex == index
                                                ? kPrimaryColor
                                                : Color(0xFFC2C2B5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GetContent(selectedIndex, serviceModel,
                                commentModel, postModelFuture, context),
                          ],

                          // GetContent(selectedIndex, serviceModel),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void moveToSecondPage(ServiceModel serviceModel) {
    Navigator.push(
      context,
      SildeRouteBT(
          page: UpdateProfileScreenService(
        serviceModel: serviceModel,
      )),
    );
  }

  Widget GetContent(
      int selectedIndex,
      ServiceModel serviceModel,
      Future<List<CommentModel>> commentModelfuture,
      Future<List<PostModel>> postModelfuture,
      context) {
    switch (selectedIndex) {
      case 0:
        return Container(
          width: getProportionateScreenWidth(350),
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    moveToSecondPage(serviceModel);
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
                ListTile(
                  leading: Icon(
                    Icons.store,
                    color: Colors.orange[300],
                  ),
                  title: Text("Tên cửa hàng"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: getProportionateScreenWidth(150),
                        child: Text(
                          serviceModel.name,
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
                    Icons.location_on,
                    color: Colors.orange[300],
                  ),
                  title: Text("Địa điểm"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: getProportionateScreenWidth(150),
                        child: Text(
                          serviceModel.address,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        double.parse(serviceModel.lat),
                        double.parse(serviceModel.long));
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer_rounded,
                    color: Colors.orange[300],
                  ),
                  title: Text("Giờ mở cửa"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: getProportionateScreenWidth(150),
                        child: Text(
                          serviceModel.open.isEmpty &&
                                  serviceModel.close.isEmpty
                              ? ''
                              : serviceModel.open + ' - ' + serviceModel.close,
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
                    Icons.phone_android,
                    color: Colors.orange[300],
                  ),
                  title: Text("Điện thoại"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: getProportionateScreenWidth(150),
                        child: Text(
                          serviceModel.phone.isEmpty ? '' : serviceModel.phone,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        break;
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Container(
                  width: getProportionateScreenWidth(300),
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.create_rounded,
                        color: kPrimaryColor,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: getProportionateScreenWidth(150),
                            child: Text(
                              "Đăng bài",
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                contentPadding: EdgeInsets.only(top: 10.0),
                                content: Container(
                                  height: getProportionateScreenHeight(300),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 8.0, 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        serviceModel.image)),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      20),
                                            ),
                                            Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      200),
                                              width:
                                                  getProportionateScreenWidth(
                                                      200),
                                              child: TextFormField(
                                                controller: titleController,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 8,
                                                maxLength: 1000,
                                                decoration: new InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: "Ghi trạng thái",
                                                    counterText: ""),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenHeight(10),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            OutlineButton(
                                              onPressed: () {
                                                _showChoiceDialog(context);
                                              },
                                              child: Text('Thêm ảnh'),
                                            ),
                                            OutlineButton(
                                              onPressed: () {
                                                uploadPost(
                                                    context, serviceModel);
                                              },
                                              child: Text('Đăng'),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                )),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            FutureBuilder<List<PostModel>>(
              future: postModelfuture,
              //we pass a BuildContext and an AsyncSnapshot object which is an
              //Immutable representation of the most recent interaction with
              //an asynchronous computation.
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PostModel> postModel = snapshot.data;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenWidth(20)),
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: postModel.length,
                        itemBuilder: (context, index) {
                          Future<bool> temp = downloadJsonCheckLike(
                              postModel[index].postId.toString());
                          Future<int> likesid =
                              downloadJsonLikes(postModel[index].postId);
                          cmntPostsid =
                              downloadJsonCmnts(postModel[index].postId);

                          if (postModel[index].postId != null) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(10),
                                vertical: getProportionateScreenHeight(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: getProportionateScreenWidth(350),
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 16.0, 8.0, 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  new Container(
                                                    height: 60.0,
                                                    width: 60.0,
                                                    decoration:
                                                        new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              postModel[index]
                                                                  .userImg)),
                                                    ),
                                                  ),
                                                  new SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      new Text(
                                                        postModel[index].name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      new Text(
                                                        getText(DateTime.parse(
                                                            postModel[index]
                                                                .date)),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              new IconButton(
                                                icon: Icon(Icons.more_vert),
                                                onPressed: null,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              getProportionateScreenWidth(10)),
                                          child: Text(
                                            postModel[index].title,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        postModel[index].image != ""
                                            ? Padding(
                                                padding: EdgeInsets.all(
                                                    getProportionateScreenWidth(
                                                        10)),
                                                child: Image(
                                                  image: NetworkImage(
                                                      postModel[index].image),
                                                  width: 125.0,
                                                  height: 250.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Container(),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Row(
                                                children: <Widget>[
                                                  FutureBuilder<bool>(
                                                    future: temp,
                                                    //we pass a BuildContext and an AsyncSnapshot object which is an
                                                    //Immutable representation of the most recent interaction with
                                                    //an asynchronous computation.
                                                    builder:
                                                        (context, snapshot) {
                                                      print(snapshot.data);
                                                      if (snapshot.hasData) {
                                                        return GestureDetector(
                                                            child: snapshot.data
                                                                ? Icon(
                                                                    Icons
                                                                        .favorite,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 40,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .favorite_border,
                                                                    color: null,
                                                                    size: 40,
                                                                  ),
                                                            onTap: () {
                                                              downloadJsonLike(
                                                                  postModel[
                                                                          index]
                                                                      .postId
                                                                      .toString());
                                                              setState(() {
                                                                temp = downloadJsonCheckLike(
                                                                    postModel[
                                                                            index]
                                                                        .postId
                                                                        .toString());
                                                                Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                    () {
                                                                  likesid = downloadJsonLikes(
                                                                      postModel[
                                                                              index]
                                                                          .postId);
                                                                });
                                                              });
                                                            });
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            '${snapshot.error}');
                                                      }
                                                      //return  a circular progress indicator.
                                                      return new CircularProgressIndicator();
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getProportionateScreenHeight(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              20),
                                                      width:
                                                          getProportionateScreenWidth(
                                                              1),
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  FutureBuilder<int>(
                                                    future: likesid,
                                                    //we pass a BuildContext and an AsyncSnapshot object which is an
                                                    //Immutable representation of the most recent interaction with
                                                    //an asynchronous computation.
                                                    builder:
                                                        (context, snapshot) {
                                                      print(snapshot.data);
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                            '${snapshot.data} lượt thích');
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            '${snapshot.error}');
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  FutureBuilder<int>(
                                                    future: cmntPostsid,
                                                    //we pass a BuildContext and an AsyncSnapshot object which is an
                                                    //Immutable representation of the most recent interaction with
                                                    //an asynchronous computation.
                                                    builder:
                                                        (context, snapshot) {
                                                      print(snapshot.data
                                                          .toString());
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                            '${snapshot.data} bình luận');
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            '${snapshot.error}');
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getProportionateScreenHeight(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              20),
                                                      width:
                                                          getProportionateScreenWidth(
                                                              1),
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.message,
                                                      size: 30,
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        SildeRouteBT(
                                                          page: DetailPost(
                                                            postModel:
                                                                postModel[
                                                                    index],
                                                            postModelList:
                                                                postModelFuture,
                                                            serviceModel:
                                                                serviceModel,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                //return  a circular progress indicator.
                return Center(child: new CircularProgressIndicator());
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(50),
            )
          ],
        );
        break;
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<CommentModel>>(
              future: commentModelfuture,
              //we pass a BuildContext and an AsyncSnapshot object which is an
              //Immutable representation of the most recent interaction with
              //an asynchronous computation.
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CommentModel> commentModel = snapshot.data;
                  print(commentModel);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: commentModel.length,
                        itemBuilder: (context, index) {
                          // if (commentModel[index].id != null) {
                          return CommentBody(
                            commentModel: commentModel[index],
                          );
                          // } else {
                          //   return Container();
                          // }
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                //return  a circular progress indicator.
                return new CircularProgressIndicator();
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(50),
            )
          ],
        );

        break;
      default:
    }
  }
}

class CommentBody extends StatefulWidget {
  CommentBody({Key key, @required this.commentModel}) : super(key: key);
  final CommentModel commentModel;
  @override
  _CommentBodyState createState() => _CommentBodyState(commentModel);
}

class _CommentBodyState extends State<CommentBody> {
  _CommentBodyState(this.commentModel);
  CommentModel commentModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(350),
      child: Card(
        color: Colors.white,
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            commentModel.fullname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          new Text(
                            getText(DateTime.parse(commentModel.date)),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  new IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: null,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Text(
                commentModel.content,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RatingBarIndicator(
                        rating: commentModel.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.yellow[600],
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<int> downloadJsonLikes(int id) async {
  final jsonEndpoint = url + "likesid";
  var idpost = json.encode(id);
  final response = await http.post(jsonEndpoint, body: {
    "postid": idpost,
  });
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<bool> downloadJsonCheckLike(String id) async {
  final jsonEndpoint = url + "checklike";
  var session = FlutterSession();

  var user = await session.get("username");
  print(user);
  print(id);
  final response = await http.post(
    jsonEndpoint,
    body: {"username": user, "postid": id},
  );
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<int> downloadJsonLike(String id) async {
  final jsonEndpoint = url + "like";
  var session = FlutterSession();

  var user = await session.get("username");
  final response = await http.post(
    jsonEndpoint,
    body: {"username": user, "postid": id},
  );
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else
    throw Exception('We were not able to successfully download the json data.');
}

class PostBody extends StatefulWidget {
  PostBody({Key key, @required this.postModel, @required this.temp})
      : super(key: key);
  final PostModel postModel;
  final Future<bool> temp;
  @override
  _PostBodyState createState() => _PostBodyState(postModel, temp);
}

class _PostBodyState extends State<PostBody> {
  _PostBodyState(this.postModel, this.temp);
  PostModel postModel;
  Future<bool> temp;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(350),
      child: Card(
        color: Colors.white,
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(postModel.userImg)),
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: new Text(
                              postModel.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          new Text(
                            getText(DateTime.parse(postModel.date)),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  new IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: null,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              child: Text(
                postModel.title,
                style: TextStyle(fontSize: 20),
              ),
            ),
            postModel.image != ""
                ? Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                    child: Image(
                      image: NetworkImage(postModel.image),
                      width: 125.0,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FutureBuilder<bool>(
                        future: temp,
                        //we pass a BuildContext and an AsyncSnapshot object which is an
                        //Immutable representation of the most recent interaction with
                        //an asynchronous computation.
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          if (snapshot.hasData) {
                            return GestureDetector(
                                child: snapshot.data
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 40,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: null,
                                        size: 40,
                                      ),
                                onTap: () {
                                  downloadJsonLike(postModel.postId.toString());
                                  setState(() {
                                    temp = downloadJsonCheckLike(
                                        postModel.postId.toString());
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          //return  a circular progress indicator.
                          return new CircularProgressIndicator();
                        },
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getText(DateTime day) {
  if (DateTime.now().difference(day).inHours < 24) {
    return "${DateTime.now().difference(day).inHours} giờ trươc";
  } else {
    if (DateTime.now().difference(day).inDays < 30) {
      return "${DateTime.now().difference(day).inDays} ngày trươc";
    } else if (DateTime.now().difference(day).inDays >= 30 &&
        DateTime.now().difference(day).inDays < 365) {
      return "${int.parse((DateTime.now().difference(day).inDays / 30).toString())} tháng trước";
    } else {
      return "${int.parse((DateTime.now().difference(day).inDays / 365).toString())} năm trước";
    }
  }
}
