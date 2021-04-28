import 'dart:ui' as ui;
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpme/Screens/Home/components/home_header.dart';
import 'package:helpme/Screens/Home/components/icon_btn_with_counter.dart';
import 'package:helpme/Screens/Profile_Service/profile_screen.dart';
import 'package:helpme/components/size_config.dart';
import 'package:helpme/components/trianglePainter.dart';
import 'package:helpme/constants.dart';
import 'package:helpme/model/catologis.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:helpme/straintion/left_right.dart';
import 'package:helpme/straintion/right_left.dart';
import 'package:intl/intl.dart';

class BodyList extends StatefulWidget {
  BodyList({Key key, @required this.serviceModelFure}) : super(key: key);
  final Future<List<ServiceModel>> serviceModelFure;
  @override
  _BodyListState createState() => _BodyListState(serviceModelFure);
}

class _BodyListState extends State<BodyList> {
  _BodyListState(this.serviceModelFure);
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  Future<List<ServiceModel>> serviceModelFure;
  List<ServiceModel> serviceModel;
  String searchkey = "";
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  // List<ServiceModel> serviceModel = [
  //   ServiceModel(
  //       name: "Cafe 1985",
  //       brand: "Quán cafe hoài cổ đẹp nhất ở Cần Thơ",
  //       rate: "3.49",
  //       image: "cafe-1985.jpg",
  //       open: "7:00",
  //       close: "23:00",
  //       address:
  //           "27:002 Đường 30 Tháng 4, Hưng Lợi, Ninh Kiều, Cần Thơ, Việt Nam"),
  //   ServiceModel(
  //     name: "Ninh Kiều Riverside Sky Bar",
  //     brand: "Quán cafe đẹp cho các cặp tình nhân",
  //     rate: "3.49",
  //     open: "7:00",
  //     close: "23:00",
  //     image: "ninh-kieu-riverside-sky-bar.jpg",
  //     address: "169B Đường 30 Tháng 4, Hưng Lợi, Ninh Kiều, Cần Thơ, Việt Nam",
  //   ),
  //   ServiceModel(
  //     name: "Quán cafe trên cây",
  //     brand: "Không gian quán phải nói là quá đẹp",
  //     rate: "3.49",
  //     open: "7:00",
  //     close: "23:00",
  //     image: "garden-cafe.jpg",
  //     address: "16 Nguyễn Thái Học, Tân An, Ninh Kiều, Cần Thơ, Việt Nam",
  //   ),
  //   ServiceModel(
  //       name: "Lotus Cà Phê Ninh Kiều",
  //       brand: "Quán rất thích hợp để đi cùng với gia đình",
  //       rate: "3.49",
  //       open: "7:00",
  //       close: "23:00",
  //       image: "lotus-coffee.jpg",
  //       address: "138 Huỳnh Cương, An Cư, Ninh Kiều, Cần Thơ, Việt Nam"),
  //   ServiceModel(
  //     name: "BroS Coffee – Cá Koi",
  //     brand: "không gian rộng rãi, thoáng mát",
  //     rate: "3.49",
  //     open: "6:00",
  //     close: "23:00",
  //     image: "bros-coffe.jpg",
  //     address: "3 Đ. Mạc Thiên Tích, Xuân Khánh, Ninh Kiều, Cần Thơ, Việt Nam",
  //   ),
  //   ServiceModel(
  //     name: "Phúc Long Coffee & Tea",
  //     brand: "Không gian tại quán nhìn cảm giác xanh, gần gũi với thiên nhiên",
  //     rate: "3.49",
  //     open: "0:00",
  //     close: "24:00",
  //     image: "coffee-and-tea.jpg",
  //     address: "8 Đại lộ Hoà Bình, P, Ninh Kiều, Cần Thơ, Việt Nam",
  //   ),
  //   ServiceModel(
  //     name: "Cafe Thủy Mộc",
  //     brand: "Quán cà phê yên tĩnh ở Cần Thơ",
  //     rate: "3.49",
  //     open: "5:00",
  //     close: "23:00",
  //     image: "cafe-thuy-moc.jpg",
  //     address: "Ba Tháng Hai, Hưng Lợi, Ninh Kiều, Cần Thơ, Việt Nam",
  //   ),
  //   ServiceModel(
  //     name: "Highlands coffee",
  //     brand:
  //         "Chất lượng và thái độ phục vụ của Highlands Coffee Cần Thơ vô cùng chuyên nghiệp",
  //     rate: "3.49",
  //     open: "7:00",
  //     close: "20:00",
  //     image: "highlands-coffee.jpg",
  //     address: "124 Đường 30 Tháng 4, Hưng Lợi, Ninh Kiều, Cần Thơ, Việt Nam",
  //   ),
  //   ServiceModel(
  //     name: "The Coffee House",
  //     brand: "Không gian quán rộng rãi, thoáng đãng, sang trọng",
  //     rate: "3.49",
  //     open: "7:00",
  //     close: "21:00",
  //     image: "the-coffee-house.jpg",
  //     address: "Đường Nguyễn Văn Linh, Street, Ninh Kiều, Cần Thơ, Việt Nam",
  //   )
  // ];
  List<Map<String, dynamic>> year = [
    {"title": "Mặc định"},
    {"title": "Lâu đời"},
    {"title": "Mới mở"},
  ];
  int year_index = 0;
  List<Map<String, dynamic>> popular = [
    {"title": "Mặc định"},
    {"title": "Phổ biến nhất"},
    {"title": "Đánh giá cao nhất"},
    {"title": "Tương tác nhiều nhất"},
  ];
  int popular_index = 0;

  List<CatologisModelF1> categoriesF3 = [
    CatologisModelF1(
      text: 'Mặc định',
      type: 0,
      about: 0,
    ),
    CatologisModelF1(
      text: 'Lâu đời',
      type: 1,
      about: 1,
    ),
    CatologisModelF1(
      text: 'Mới mở',
      type: 2,
      about: 2,
    ),
    CatologisModelF1(
      text: 'Phổ biến nhất',
      type: 3,
      about: 3,
    ),
    CatologisModelF1(
      text: 'Đánh giá cao nhất',
      type: 4,
      about: 4,
    ),
    CatologisModelF1(
      text: 'Tương tác cao nhất',
      type: 5,
      about: 5,
    ),
  ];
  CatologisModelF1 dropdownValueOld;
  CatologisModelF1 dropdownValuePopu;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
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
                          searchkey = value;
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
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10),
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sắp xếp theo',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // dropdown below..
                            child: DropdownButton<CatologisModelF1>(
                                value: dropdownValueOld,
                                hint: Text("Theo ngày thành lập"),
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 40,
                                underline: SizedBox(),
                                onChanged: (CatologisModelF1 value) {
                                  setState(() {
                                    dropdownValueOld = value;
                                  });
                                },
                                items:
                                    categoriesF3.map((CatologisModelF1 value) {
                                  return DropdownMenuItem<CatologisModelF1>(
                                    value: value,
                                    child: Text(value.text),
                                  );
                                }).toList()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height - getProportionateScreenHeight(260),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: closeTopContainer ? 0 : 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: size.width,
                      alignment: Alignment.topCenter,
                      height: closeTopContainer
                          ? 0
                          : getProportionateScreenHeight(40),
                      child: Text(
                        'Địa điểm gần đây',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(20),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<List<ServiceModel>>(
                    future: serviceModelFure,
                    //we pass a BuildContext and an AsyncSnapshot object which is an
                    //Immutable representation of the most recent interaction with
                    //an asynchronous computation.
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        serviceModel = snapshot.data;

                        if (dropdownValueOld != null) {
                          if (dropdownValueOld.type == 1) {
                            serviceModel.sort((a, b) {
                              var adate =
                                  a.birthDay; //before -> var adate = a.expiry;
                              var bdate = b.birthDay; //var bdate = b.expiry;
                              return -adate.compareTo(bdate);
                            });
                          } else if (dropdownValueOld.type == 2) {
                            serviceModel.sort((a, b) {
                              var adate =
                                  a.birthDay; //before -> var adate = a.expiry;
                              var bdate = b.birthDay; //var bdate = b.expiry;
                              return adate.compareTo(bdate);
                            });
                          } else if (dropdownValueOld.type == 0) {
                            serviceModel.sort((a, b) {
                              var adate =
                                  a.distance; //before -> var adate = a.expiry;
                              var bdate = b.distance; //var bdate = b.expiry;
                              return adate.compareTo(bdate);
                            });
                          } else if (dropdownValueOld.type == 3) {
                            serviceModel.sort((a, b) {
                              var adate =
                                  a.countCmt; //before -> var adate = a.expiry;
                              var bdate = b.countCmt; //var bdate = b.expiry;
                              return -adate.compareTo(bdate);
                            });
                          } else if (dropdownValueOld.type == 4) {
                            serviceModel.sort((a, b) {
                              var adate =
                                  a.rate; //before -> var adate = a.expiry;
                              var bdate = b.rate; //var bdate = b.expiry;
                              return -adate.compareTo(bdate);
                            });
                          } else if (dropdownValueOld.type == 5) {
                            serviceModel.sort((a, b) {
                              var adate =
                                  a.countPost; //before -> var adate = a.expiry;
                              var bdate = b.countPost; //var bdate = b.expiry;
                              return -adate.compareTo(bdate);
                            });
                          }
                        }
                        return Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: serviceModel.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              double scale = 1.0;
                              if (topContainer > 0.5) {
                                scale = index + 0.5 - topContainer;
                                if (scale < 0) {
                                  scale = 0;
                                } else if (scale > 1) {
                                  scale = 1;
                                }
                              }
                              print(serviceModel[0].name);
                              return serviceModel[index].name.contains(
                                          new RegExp(searchkey,
                                              caseSensitive: false)) ||
                                      serviceModel[index].brand.contains(
                                          new RegExp(searchkey,
                                              caseSensitive: false)) ||
                                      serviceModel[index].decription.contains(
                                          new RegExp(searchkey,
                                              caseSensitive: false))
                                  ? CardService(
                                      scale: scale,
                                      serviceModel: serviceModel,
                                      index: index)
                                  : Container();
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      //return  a circular progress indicator.
                      return Center(child: new CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardService extends StatelessWidget {
  const CardService({
    Key key,
    @required this.scale,
    @required this.index,
    @required this.serviceModel,
  }) : super(key: key);
  final int index;
  final double scale;
  final List<ServiceModel> serviceModel;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: scale,
      child: Transform(
        transform: Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.bottomCenter,
        child: Align(
          heightFactor: 0.7,
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              SlideRightRouteRL(
                page: ServieProfileScreen(
                  serviceModel: serviceModel[index],
                ),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 10.0),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: getProportionateScreenWidth(200),
                              child: Text(
                                serviceModel[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: getProportionateScreenWidth(150),
                              child: Text(
                                double.parse(serviceModel[index].distance) < 1
                                    ? "Cách: " +
                                        (double.parse(serviceModel[index]
                                                    .distance) *
                                                1000)
                                            .toStringAsFixed(0) +
                                        "m"
                                    : "Cách: " +
                                        double.parse(
                                                serviceModel[index].distance)
                                            .toStringAsFixed(2) +
                                        "km",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RatingBarIndicator(
                              rating: double.parse(serviceModel[index].rate),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.yellow[600],
                              ),
                              itemCount: 5,
                              itemSize: 25.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        Image.network(
                          serviceModel[index].image,
                          height: double.infinity,
                          width: getProportionateScreenWidth(100),
                        )
                      ],
                    ),
                  ),
                ),
                serviceModel[index].title.isEmpty ||
                        serviceModel[index].title == ""
                    ? Container()
                    : Positioned(
                        top: 1,
                        right: 19,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 8.0,
                              width: 5.0,
                              child: CustomPaint(
                                painter: TrianglePainter(),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      colorConvert(serviceModel[index].color),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(6.0),
                                      bottomLeft: Radius.circular(6.0))),
                              width: 120.0,
                              height: 30.0,
                              child: Center(
                                child: Text(
                                  serviceModel[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    var converted;
    if (color.length == 6) {
      converted = Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      converted = Color(int.parse("0x" + color));
    }
    return converted;
  }
}
