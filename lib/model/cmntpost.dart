import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

class CmntPostModel {
  final int postid;
  final int id;
  final String content;
  final String fullname;
  final String date;
  final String avatar;
  CmntPostModel({
    this.postid,
    this.id,
    this.content,
    this.fullname,
    this.date,
    this.avatar,
  });
  factory CmntPostModel.fromJson(Map<String, dynamic> jsonData) {
    return CmntPostModel(
      postid: jsonData['postid'],
      date: jsonData['date'],
      id: jsonData['id'],
      content: jsonData['content'],
      fullname: jsonData['fullname'],
      avatar: jsonData['avatar'],
    );
  }
}
