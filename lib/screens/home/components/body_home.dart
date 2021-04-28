import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpme/Screens/Home/components/button_search.dart';
import 'package:helpme/Screens/Home/components/home_header.dart';
import 'package:helpme/Screens/Home/components/search_field.dart';
import 'package:helpme/Screens/Home/components/section_title.dart';
import 'package:helpme/Screens/Home/components/srollbar_range.dart';
import 'package:helpme/Screens/List/components/list_body.dart';
import 'package:helpme/Screens/List/list_search.dart';
import 'package:helpme/Screens/map_picker/map_picker.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/model/catologis.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/straintion/right_left.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categories.dart';
import 'icon_btn_with_counter.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
  static _HomeBodyState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeBodyState>();
}

typedef void IntArrCallback(
  List<int> intArr,
  double range,
  String lat,
  String long,
);

class _HomeBodyState extends State<HomeBody> {
  List<int> intArr = [];
  double range;
  String lat;
  var location = Location();
  String long;
  Future<List<ServiceModel>> servicemoRdel;
  String searchKey = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get();
  }

  get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lat = prefs?.getString("lat");
    long = prefs?.getString("long");
    print(lat);
    print(long);
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            prefs?.setString("lat", locationData.latitude.toString());
            prefs?.setString("long", locationData.longitude.toString());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 0.72,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchKey = value;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenWidth(9)),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Search product",
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                  IconBtnWithCounter(
                    svgSrc: "assets/icons/Bell.svg",
                    numOfitem: 3,
                    press: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            Padding(
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
                          return categoriesF1[index].text.contains(
                                    new RegExp(searchKey, caseSensitive: false),
                                  )
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
                                        intArr.remove(categoriesF1[index].type);
                                      } else {
                                        categoriesF1[index].selected = true;
                                        intArr.add(categoriesF1[index].type);
                                      }
                                    });
                                  },
                                )
                              : Container(
                                  height: getProportionateScreenHeight(100),
                                );
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
                          return categoriesF2[index].text.contains(
                                    new RegExp(searchKey, caseSensitive: false),
                                  )
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
                                        intArr.remove(categoriesF2[index].type);
                                      } else {
                                        categoriesF2[index].selected = true;
                                        intArr.add(categoriesF2[index].type);
                                      }
                                    });
                                  },
                                )
                              : Container(
                                  height: getProportionateScreenHeight(100),
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ButtonSearch(
              size: 150,
              padding: 50,
              press: () async {
                for (final f in categoriesF1) {
                  f.selected = false;
                }
                for (final f in categoriesF2) {
                  f.selected = false;
                }
                print(intArr);
                Navigator.push(
                  context,
                  SlideRightRouteRL(
                    page: ListScreens(
                        serviceModelFure: downloadJSONMyService(
                            intArr.length == 0 ? [-1] : intArr,
                            range == null ? 3000.0 : range,
                            lat,
                            long)),
                  ),
                );
              },
              icon: 'assets/icons/transparency.svg',
            ),
            SrollBarRange(),
          ],
        ),
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
