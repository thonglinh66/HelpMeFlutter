import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

class CommentModel {
  final int serviceId;
  final int id;
  final String content;
  final String fullname;
  final String date;
  final double rating;
  CommentModel({
    this.serviceId,
    this.id,
    this.content,
    this.fullname,
    this.date,
    this.rating,
  });
  factory CommentModel.fromJson(Map<String, dynamic> jsonData) {
    return CommentModel(
      rating: double.parse(jsonData['rating'].toString()),
      date: jsonData['date'],
      id: jsonData['id'],
      content: jsonData['comment'],
      fullname: jsonData['fullname'],
      serviceId: jsonData['serviceId'],
    );
  }
}
