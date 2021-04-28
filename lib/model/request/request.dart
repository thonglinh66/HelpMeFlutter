import 'dart:convert';
import 'dart:developer';

import 'package:flutter_session/flutter_session.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/model/like.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/model/servicelogin.dart';
import 'package:helpme/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../comment.dart';
import '../post.dart';

Future<List<ServiceModel>> downloadJSONMyService(
    List<int> typeArr, double range, String lat, String long) async {
  final jsonEndpoint = url + "getservice";

  var rangepost = json.encode(range);
  var type = json.encode(typeArr);

  print(rangepost);
  print(type);
  print(lat);
  print(long);
  final response = await http.post(jsonEndpoint, body: {
    "long": long,
    "lat": lat,
    "type": type,
    "range": rangepost,
  });
  print(long);
  print(lat);
  print(response.body);
  if (response.statusCode == 200) {
    List services = json.decode(response.body);
    return services
        .map((service) => new ServiceModel.fromJson(service))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<List<PostModel>> downloadJSONPost(int username) async {
  final jsonEndpoint = url + "getpost";

  var usernameId = json.encode(username);

  final response = await http.post(jsonEndpoint, body: {
    "username": usernameId,
  });
  print(response.body);
  if (response.statusCode == 200) {
    List postModels = json.decode(response.body);
    return postModels
        .map((postModel) => new PostModel.fromJson(postModel))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<List<CommentModel>> downloadJSONComment(int service) async {
  final jsonEndpoint = url + "listcomment";

  var usernameId = json.encode(service);

  final response = await http.post(jsonEndpoint, body: {
    "service": usernameId,
  });
  print(response.body);
  if (response.statusCode == 200) {
    List commentModels = json.decode(response.body);
    return commentModels
        .map((commentModel) => new CommentModel.fromJson(commentModel))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<ServiceModel> downloadJsonUserService() async {
  final jsonEndpoint = url + "serviceretrive";
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var user = prefs?.getString("username");

  final response = await http.post(jsonEndpoint, body: {
    "username": user,
  });
  if (response.statusCode == 200) {
    return ServiceModel.fromJson(json.decode(response.body)[0]);
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<UserModel> downloadJsonUser() async {
  final jsonEndpoint = url + "retrieve";
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var user = prefs?.getString("username");
  final response = await http.post(jsonEndpoint, headers: {
    "Connection": "keep-alive"
  }, body: {
    "username": user,
  });
  print(response.body);

  if (response.statusCode == 200) {
    return UserModel.fromJson(json.decode(response.body)[0]);
  } else
    throw Exception('We were not able to successfully download the json data.');
}

Future<ServiceModelLogin> downloadJsonService() async {
  final jsonEndpoint = url + "retrieve";
  var session = FlutterSession();

  var user = await session.get("username");

  final response = await http.post(jsonEndpoint, body: {
    "username": user,
  });

  if (response.statusCode == 200) {
    return ServiceModelLogin.fromJson(json.decode(response.body));
  } else
    throw Exception('We were not able to successfully download the json data.');
}
