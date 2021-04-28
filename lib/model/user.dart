import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserModel {
  final int id;
  final String name;
  final String username;

  final String decript;
  final String birth;
  final String image;
  final String imageOld;
  final String background;
  UserModel({
    this.id,
    this.username,
    this.image,
    this.imageOld,
    this.decript,
    this.birth,
    this.name,
    this.background,
  });
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      id: jsonData['id'],
      name: jsonData['fullname'],
      username: jsonData['username'],
      decript: jsonData['decription'],
      birth: jsonData['birthday'],
      imageOld: jsonData['oldimage'],
      image: jsonData['avatar'],
      background: jsonData['background'],
    );
  }
}
