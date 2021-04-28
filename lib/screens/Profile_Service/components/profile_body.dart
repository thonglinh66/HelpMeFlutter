import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/Screens/Home/components/button_search.dart';
import 'package:helpme/Screens/List/list_search.dart';
import 'package:helpme/Screens/Profile_Service/components/container.dart';
import 'package:helpme/Screens/Profile_Service/components/tab_bar.dart';
import 'package:helpme/Screens/Profile_User_Service/components/profile_body.dart';
import 'package:helpme/components/categoriesfirst.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/model/comment.dart';
import 'package:helpme/model/post.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/post/post_screens.dart';
import 'package:helpme/straintion/bottom_top.dart';
import 'package:helpme/straintion/left_right.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../../constants.dart';
import 'Unline.dart';
import 'background.dart';
import 'decription.dart';
import 'informatio.dart';
import 'logo.dart';
import 'name.dart';
import 'package:jiffy/jiffy.dart';

class ServiceProfilePage extends StatefulWidget {
  const ServiceProfilePage({
    Key key,
    this.postModelFuture,
    this.index,
    @required this.serviceModel,
  }) : super(key: key);
  final int index;
  final ServiceModel serviceModel;
  final Future<List<PostModel>> postModelFuture;

  @override
  _ServiceProfilePageState createState() =>
      _ServiceProfilePageState(serviceModel, postModelFuture, index);
}

class _ServiceProfilePageState extends State<ServiceProfilePage> {
  Future<List<PostModel>> postModelFuture;
  ServiceModel serviceModel;
  _ServiceProfilePageState(
      this.serviceModel, this.postModelFuture, this.selectedIndex);

  List<String> categories = [
    "Thông tin",
    "Bài đăng",
    "Bình luận",
  ];
  Future<int> cmntPostsid;
  int selectedIndex;
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  Future<List<CommentModel>> commentModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (selectedIndex == null) {
      selectedIndex = 0;
    }

    print(serviceModel.username);
    postModelFuture = downloadJSONPost(serviceModel.username);
    commentModel = downloadJSONComment(serviceModel.username);
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenHeight(7),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: getProportionateScreenHeight(5)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getProportionateScreenHeight(30), //20
                                  ),
                                  decoration: BoxDecoration(
                                      color: selectedIndex == index
                                          ? Color(0xFFEFF3EE)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        getProportionateScreenHeight(10), // 16
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
                      GetContent(selectedIndex, serviceModel, commentModel,
                          postModelFuture, context)
                    ],

                    // GetContent(selectedIndex, serviceModel),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 25.0,
            left: 12.0,
            child: ButtonSearch(
              size: 50,
              padding: 12,
              press: () {
                Navigator.pop(
                  context,
                  SlideRightRouteLR(
                    page: ListScreens(),
                  ),
                );
              },
              icon: 'assets/icons/back.svg',
            ),
          ),
        ],
      ),
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
                return new CircularProgressIndicator();
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(40)),
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
                            "Nhập bình luận",
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var type = prefs?.getString("type");
                      if (type == "1") {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: Row(
                                  children: <Widget>[
                                    Text("Bạn không có quyền bình luận"),
                                    Icon(Icons.error_outline_outlined,
                                        color: Colors.red),
                                  ],
                                ),
                              );
                            });
                      } else {
                        _showComment(context, serviceModel);
                      }
                    },
                  ),
                ),
              ),
            ),
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

  Future<void> _showComment(BuildContext context, ServiceModel serviceModel) {
    var rating = 1.0;
    TextEditingController cmntController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Rate",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SmoothStarRating(
                        rating: rating,
                        isReadOnly: false,
                        size: 26,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: true,
                        spacing: 2.0,
                        onRated: (value) {
                          rating = value;
                          // print("rating value dd -> ${value.truncate()}");
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: cmntController,
                      decoration: InputDecoration(
                        hintText: "Add Review",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Bình Luận",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var username = prefs?.getString("username");

                      try {
                        final response =
                            await http.post(url + "comment", body: {
                          "username": username,
                          "comment": cmntController.text,
                          "serviceId": json.encode(serviceModel.username),
                          "rating": json.encode(rating),
                        });
                        print(response.body);
                        if (response.statusCode == 200) {
                          setState(() {
                            commentModel =
                                downloadJSONComment(serviceModel.username);
                          });
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
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

String getText(DateTime day) {
  if (DateTime.now().difference(day).inMilliseconds < 60) {
    return "${DateTime.now().difference(day).inMinutes} giây trước";
  } else if (DateTime.now().difference(day).inMinutes < 60) {
    return "${DateTime.now().difference(day).inMinutes} phút trước";
  } else if (DateTime.now().difference(day).inHours < 24) {
    return "${DateTime.now().difference(day).inHours} giờ trước";
  } else {
    if (DateTime.now().difference(day).inDays < 30) {
      return "${DateTime.now().difference(day).inDays} ngày trước";
    } else if (DateTime.now().difference(day).inDays >= 30 &&
        DateTime.now().difference(day).inDays < 365) {
      double temp = (DateTime.now().difference(day).inDays / 30);
      int value = temp.toInt();
      return "${value.toString()} tháng trước";
    } else {
      double temp = (DateTime.now().difference(day).inDays / 365);
      int value = temp.toInt();
      return "${value.toString()} năm trước";
    }
  }
}
