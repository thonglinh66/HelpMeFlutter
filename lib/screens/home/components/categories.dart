import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpme/Screens/Home/components/section_title.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/model/catologis.dart';
import 'dart:core';
import 'body_home.dart';
import 'button_search.dart';

class Categories extends StatefulWidget {
  List<CatologisModelF1> categoriesF1;
  List<CatologisModelF2> categoriesF2;
  Categories({Key key, @required this.searchKey}) : super(key: key);
  final String searchKey;
  @override
  _CategoriesState createState() => _CategoriesState(searchKey);
}

typedef void IntArrCallback(List<int> intArr, String searchKey);

class _CategoriesState extends State<Categories> {
  _CategoriesState(searchKey);
  String searchKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(20)),
            child: SectionTitle(title: "Loại địa điểm", press: () {}),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                categoriesF1.length,
                (index) {
                  // return Container(
                  //     height: 10, width: 10, color: kPrimaryLightColor);
                  return categoriesF1[index].text.contains(searchKey)
                      ? CategoryCard(
                          icon: categoriesF1[index].icon,
                          text: categoriesF1[index].text,
                          color: categoriesF1[index].selected
                              ? kPrimaryColor
                              : kPrimaryLightColor,
                          iconColor: categoriesF1[index].selected
                              ? Colors.white
                              : kPrimaryColor,
                          press: () {
                            setState(() {
                              print(categoriesF1[index].selected);

                              if (categoriesF1[index].selected) {
                                categoriesF1[index].selected = false;
                                HomeBody.of(context)
                                    .intArr
                                    .remove(categoriesF1[index].type);
                              } else {
                                categoriesF1[index].selected = true;
                                HomeBody.of(context)
                                    .intArr
                                    .add(categoriesF1[index].type);
                              }
                            });
                          },
                        )
                      : Container();
                },
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                categoriesF2.length,
                (index) {
                  // return Container(
                  //     height: 10, width: 10, color: kPrimaryLightColor);
                  return categoriesF2[index].text.contains(searchKey)
                      ? CategoryCard(
                          icon: categoriesF2[index].icon,
                          text: categoriesF2[index].text,
                          color: categoriesF2[index].selected
                              ? kPrimaryColor
                              : kPrimaryLightColor,
                          iconColor: categoriesF2[index].selected
                              ? Colors.white
                              : kPrimaryColor,
                          press: () {
                            setState(() {
                              print(categoriesF2[index].selected);

                              if (categoriesF2[index].selected) {
                                categoriesF2[index].selected = false;
                                HomeBody.of(context)
                                    .intArr
                                    .remove(categoriesF2[index].type);
                              } else {
                                categoriesF2[index].selected = true;
                                HomeBody.of(context)
                                    .intArr
                                    .add(categoriesF2[index].type);
                              }
                            });
                          },
                        )
                      : Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
    @required this.color,
    @required this.iconColor,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;
  final Color color, iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(55),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                height: getProportionateScreenWidth(55),
                width: getProportionateScreenWidth(55),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  icon,
                  color: iconColor,
                ),
              ),
              SizedBox(height: 5),
              Text(text, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}
