import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

class PostModel {
  final int usernameId;
  final int postId;
  final String title;
  final String username;
  final String image;
  final String userImg;
  final String date;
  final int countLike;
  final int countCmt;
  final String name;
  PostModel({
    this.image,
    this.username,
    this.countLike,
    this.countCmt,
    this.userImg,
    this.title,
    this.postId,
    this.usernameId,
    this.date,
    this.name,
  });
  factory PostModel.fromJson(Map<String, dynamic> jsonData) {
    return PostModel(
      image: jsonData['image'],
      countCmt: 3,
      countLike: jsonData['countlike'],
      date: jsonData['date'],
      postId: jsonData['postid'],
      title: jsonData['title'],
      userImg: jsonData['avatar'],
      username: jsonData['username'],
      name: jsonData['name'],
      usernameId: jsonData['id'],
    );
  }
}
