import 'package:flutter/material.dart';

class CatologisModelF1 {
  final String text;
  final String icon;
  final int type;
  final int about;
  bool selected = false;
  double position = 0;
  CatologisModelF1({this.icon, this.text, this.type, this.about});
}

List<CatologisModelF1> categoriesF1 = [
  CatologisModelF1(
    icon: 'assets/icons/coffee-cup.svg',
    text: 'Cafe',
    type: 1,
  ),
  CatologisModelF1(
    icon: 'assets/icons/camera.svg',
    text: 'Rạp phim',
    type: 2,
  ),
  CatologisModelF1(
    icon: 'assets/icons/amusement-park.svg',
    text: 'Giải trí',
    type: 3,
  ),
  CatologisModelF1(
    icon: 'assets/icons/hospital.svg',
    text: 'Bệnh viện',
    type: 4,
  ),
  CatologisModelF1(
    icon: 'assets/icons/hotel.svg',
    text: 'Khách sạn',
    type: 5,
  ),
];

class CatologisModelF2 {
  final String text;
  final String icon;
  final int type;
  final int about;
  bool selected = false;
  double position = 0;
  CatologisModelF2({this.icon, this.text, this.type, this.about});
}

List<CatologisModelF2> categoriesF2 = [
  CatologisModelF2(
    icon: 'assets/icons/fuel-station.svg',
    text: 'Trạm xăng',
    type: 6,
  ),
  CatologisModelF2(
    icon: 'assets/icons/shoe-shop.svg',
    text: 'Shop',
    type: 7,
  ),
  CatologisModelF2(
    icon: 'assets/icons/car-repair.svg',
    text: 'Sửa xe',
    type: 8,
  ),
  CatologisModelF2(
    icon: 'assets/icons/dish.svg',
    text: 'Quán ăn',
    type: 9,
  ),
  CatologisModelF2(
    icon: 'assets/icons/cart.svg',
    text: 'Siêu thị',
    type: 10,
  ),
  CatologisModelF2(
    icon: 'assets/icons/Plus Icon.svg',
    text: 'Khác',
    type: 0,
  ),
];
