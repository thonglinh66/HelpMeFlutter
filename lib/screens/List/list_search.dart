import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpme/Screens/List/components/list_body.dart';
import 'package:helpme/Screens/map_picker/map_picker.dart';
import 'package:helpme/components/coustom_bottom_nav_bar.dart';
import 'package:helpme/components/enums.dart';
import 'package:helpme/model/request/request.dart';
import 'package:helpme/model/service.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreens extends StatefulWidget {
  ListScreens({Key key, this.serviceModelFure, this.lat, this.long})
      : super(key: key);
  final Future<List<ServiceModel>> serviceModelFure;
  final String lat;
  final String long;
  @override
  _ListScreensState createState() =>
      _ListScreensState(serviceModelFure, lat, long);
}

class _ListScreensState extends State<ListScreens> {
  _ListScreensState(this.serviceModelFure, this.lat, this.long);
  Future<List<ServiceModel>> serviceModelFure;
  String lat;
  String long;
  Widget body;
  var location = Location();
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
    setState(() {
      body = BodyList(
        serviceModelFure: serviceModelFure == null
            ? downloadJSONMyService([-1], 3000.0, lat, long)
            : serviceModelFure,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body == null ? CircularProgressIndicator() : body,
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.list),
    );
  }
}
