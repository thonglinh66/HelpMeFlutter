import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:convert';

class LikeModel {
  final int usernameId;
  final int postId;
  final int id;

  LikeModel({
    this.id,
    this.postId,
    this.usernameId,
  });
  factory LikeModel.fromJson(Map<String, dynamic> jsonData) {
    return LikeModel(
      id: jsonData['id'],
      postId: jsonData['postid'],
      usernameId: jsonData['id'],
    );
  }
}
