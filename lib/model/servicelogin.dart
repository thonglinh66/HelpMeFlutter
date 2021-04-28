import 'package:flutter/material.dart';

class ServiceModelLogin {
  final String name;
  final int id;
  final String brand;
  final double rate;
  final String username;
  final String image;
  final String address;
  final String open, close;
  final String lat, long;
  final String background;
  ServiceModelLogin({
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
  });
  factory ServiceModelLogin.fromJson(Map<String, dynamic> jsonData) {
    return ServiceModelLogin(
      id: jsonData['id'],
      name: jsonData['fullname'],
      username: jsonData['username'],
      brand: jsonData['decription'],
      image: jsonData['avatar'],
      background: jsonData['background'],
      open: jsonData['open'],
      close: jsonData['close'],
      address: jsonData['address'],
      lat: jsonData['lat'],
      long: jsonData['long'],
      rate: jsonData['rate'],
    );
  }
}
