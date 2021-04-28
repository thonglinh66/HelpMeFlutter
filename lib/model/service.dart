import 'package:flutter/material.dart';

class ServiceModel {
  final String name;
  final int id;
  final String color;

  final String title;
  final String brand;
  final String rate;
  final int username;
  final String distance;
  final String image;
  final String decription;
  final String address;
  final String open, close;
  final String lat;
  final String long;
  final String background;
  final int type;
  final String birthDay;
  final int countPost;
  final int countCmt;
  final String phone;
  ServiceModel({
    this.phone,
    this.title,
    this.color,
    this.image,
    this.id,
    this.username,
    this.brand,
    this.rate,
    this.open,
    this.close,
    this.background,
    this.name,
    this.address,
    this.lat,
    this.long,
    this.type,
    this.distance,
    this.birthDay,
    this.decription,
    this.countPost,
    this.countCmt,
  });
  factory ServiceModel.fromJson(Map<String, dynamic> jsonData) {
    return ServiceModel(
      phone: jsonData['phone'],
      id: jsonData['id'],
      title: jsonData['nametitle'],
      image: jsonData['avatar'],
      background: jsonData['background'],
      lat: jsonData['latitude'],
      long: jsonData['longitude'],
      color: jsonData['color'],
      address: jsonData['nameaddr'],
      name: jsonData['name'],
      username: jsonData['usernameid'],
      rate: jsonData['rating'].toString(),
      open: jsonData['open'],
      close: jsonData['close'],
      type: jsonData['type'],
      distance: jsonData['distance'].toString(),
      brand: jsonData['brand'],
      birthDay: jsonData['birthday'].toString(),
      decription: jsonData['decription'],
      countPost: jsonData['countpost'] == null ? 0 : jsonData['countpost'],
      countCmt: jsonData['countcmt'] == null ? 0 : jsonData['countcmt'],
    );
  }
}
