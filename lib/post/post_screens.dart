import 'dart:convert';
import 'package:helpme/model/cmntpost.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/Screens/Home/components/button_search.dart';
import 'package:helpme/Screens/Profile_Service/profile_screen.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/model/post.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/straintion/bottom_top.dart';
import 'package:helpme/straintion/top_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class DetailPost extends StatefulWidget {
  DetailPost(
      {Key key,
      @required this.postModel,
      @required this.postModelList,
      @required this.serviceModel})
      : super(key: key);
  final PostModel postModel;
  final ServiceModel serviceModel;
  final Future<List<PostModel>> postModelList;
  @override
  _DetailPostState createState() =>
      _DetailPostState(postModel, postModelList, serviceModel);
}

class _DetailPostState extends State<DetailPost> {
  PostModel postModel;
  Future<List<PostModel>> postModelList;
  ServiceModel serviceModel;
  _DetailPostState(this.postModel, this.postModelList, this.serviceModel);
  Future<bool> temp;
  Future<int> likesid;
  Future<int> cmntPostsid;
  List<CmntPostModel> listcmnt;
  bool more = false;
  bool checklike;
  Future<List<CmntPostModel>> postfuture;
  TextEditingController cmntController = TextEditingController();
  Future<int> downloadJsonLikes(int id) async {
    final jsonEndpoint = url + "likesid";
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
      throw Exception(
          'We were not able to successfully download the json data.');
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
      throw Exception(
          'We were not able to successfully download the json data.');
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
    temp = downloadJsonCheckLike(postModel.postId.toString());
    likesid = downloadJsonLikes(postModel.postId);
    postfuture = downloadJSONComment(postModel.postId);
    cmntPostsid = downloadJsonCmnts(postModel.postId);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: getProportionateScreenHeight(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                child: Icon(Icons.arrow_back_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: ServieProfileScreen(
                                        serviceModel: serviceModel,
                                        index: 1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              new SizedBox(
                                width: 20.0,
                              ),
                              new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      postModel.userImg,
                                    ),
                                  ),
                                ),
                              ),
                              new SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    postModel.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                            icon: Icon(Icons.more_horiz),
                            onPressed: null,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(660),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(
                                    getProportionateScreenWidth(10)),
                                child: Text(
                                  postModel.title,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              postModel.image.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenWidth(10)),
                                      child: Image(
                                        image: NetworkImage(postModel.image),
                                        width: 400.0,
                                        height: 250.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              checklike = snapshot.data;

                                              return GestureDetector(
                                                  child: checklike
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
                                                    downloadJsonLike(postModel
                                                        .postId
                                                        .toString());
                                                    setState(() {
                                                      likesid =
                                                          downloadJsonLikes(
                                                              postModel.postId);

                                                      temp =
                                                          downloadJsonCheckLike(
                                                              postModel.postId
                                                                  .toString());
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return Text('${snapshot.error}');
                                            }
                                            //return  a circular progress indicator.
                                            return new CircularProgressIndicator();
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    20),
                                            width:
                                                getProportionateScreenWidth(1),
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        FutureBuilder<int>(
                                          future: likesid,
                                          //we pass a BuildContext and an AsyncSnapshot object which is an
                                          //Immutable representation of the most recent interaction with
                                          //an asynchronous computation.
                                          builder: (context, snapshot) {
                                            print(snapshot.data.toString());
                                            if (snapshot.hasData) {
                                              return Text(
                                                  '${snapshot.data} lượt thích');
                                            } else if (snapshot.hasError) {
                                              return Text('${snapshot.error}');
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width:
                                              getProportionateScreenHeight(115),
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
                                          builder: (context, snapshot) {
                                            print(snapshot.data.toString());
                                            if (snapshot.hasData) {
                                              return Text(
                                                  '${snapshot.data} bình luận');
                                            } else if (snapshot.hasError) {
                                              return Text('${snapshot.error}');
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    20),
                                            width:
                                                getProportionateScreenWidth(1),
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        InkWell(
                                          child: Icon(
                                            Icons.message_outlined,
                                            size: 35.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: getProportionateScreenWidth(350),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            getProportionateScreenHeight(10),
                                        horizontal:
                                            getProportionateScreenHeight(10),
                                      ),
                                      child: Text(
                                          more == false ? "Tất cả" : "Ấn bớt",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          )),
                                    ),
                                    Icon(
                                      more == false
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_drop_up,
                                      size: 30,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    more = !more;
                                  });
                                },
                              ),
                              FutureBuilder<List<CmntPostModel>>(
                                future: postfuture,
                                //we pass a BuildContext and an AsyncSnapshot object which is an
                                //Immutable representation of the most recent interaction with
                                //an asynchronous computation.
                                //
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: more == true
                                          ? snapshot.data.length
                                          : snapshot.data.length < 3
                                              ? snapshot.data.length
                                              : 3,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getProportionateScreenWidth(15),
                                            vertical:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top:
                                                      getProportionateScreenHeight(
                                                          8),
                                                ),
                                                child: new Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                        snapshot
                                                            .data[index].avatar,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(15),
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                    ),
                                                    color: kPrimaryLightColor,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          getProportionateScreenWidth(
                                                              15),
                                                      vertical:
                                                          getProportionateScreenHeight(
                                                              15),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom:
                                                                getProportionateScreenHeight(
                                                                    10),
                                                          ),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                        .fullname ==
                                                                    null
                                                                ? "User " +
                                                                    index
                                                                        .toString()
                                                                : snapshot
                                                                    .data[index]
                                                                    .fullname,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 19,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data[index]
                                                                      .content ==
                                                                  null
                                                              ? "Error"
                                                              : snapshot
                                                                  .data[index]
                                                                  .content,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
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
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text("${snapshot.error}"),
                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              // You can change the duration and curve as per your requirement:
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextField(
                        controller: cmntController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập bình luận ...',
                        ),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        width: 60,
                        child: Icon(Icons.send),
                      ),
                      onTap: () {
                        if (cmntController.text.isEmpty) {
                        } else {
                          _postcmnt(cmntController.text, postModel.postId);
                        }
                        setState(() {
                          postfuture = downloadJSONComment(postModel.postId);
                          cmntPostsid = downloadJsonCmnts(postModel.postId);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// } else {
//   return Container();
// }
  Future _postcmnt(String content, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs?.getString("username");
    var postid = json.encode(id);
    try {
      final response = await http.post(url + "postCmntPost", body: {
        "username": username,
        "content": content,
        "postid": postid,
      });

      if (response.body != "999") {
        cmntController.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<CmntPostModel>> downloadJSONComment(int postid) async {
    final jsonEndpoint = url + "cmntPost";

    var usernameId = json.encode(postid);

    final response = await http.post(jsonEndpoint, body: {
      "postid": usernameId,
    });
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      List commentModels = json.decode(response.body);
      return commentModels
          .map((commentModel) => new CmntPostModel.fromJson(commentModel))
          .toList();
    } else
      throw Exception('Không có dữ liệu');
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
}
