import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpme/components/rounded_button.dart';
import 'package:helpme/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;

class BodyMap extends StatefulWidget {
  @override
  _BodyMapState createState() => _BodyMapState();
}

class _BodyMapState extends State<BodyMap> {
  GoogleMapController mapController;
  List<Marker> myMarker = [];
  String searchAddr;
  LatLng selectLocation;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);

      _handleTap(
        LatLng(position.latitude, position.longitude),
      );
      CameraPosition(target: _initialPosition, zoom: 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    if (_initialPosition != null) {
      return Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController googleMapController) {
              mapController = googleMapController;
            },
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 15),
            markers: Set.from(myMarker),
            onTap: _handleTap,
          ),
          Positioned(
            top: 15.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kPrimaryLightColor,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter your location",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchandNavigate,
                    iconSize: 30.0,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 15.0,
            right: 65.0,
            left: 65.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: kPrimaryLightColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: RoundedButton(
                  text: "Chọn",
                  press: () async {
                    Navigator.pop(context, selectLocation);
                  },
                  color: kPrimaryColor,
                  textcolor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then(
      (result) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  result[0].position.latitude, result[0].position.longitude),
              zoom: 15,
            ),
          ),
        );
        _handleTap(
          LatLng(result[0].position.latitude, result[0].position.longitude),
        );
      },
    );
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          icon: BitmapDescriptor.fromAsset('assets/images/store.png'),
        ),
      );
      selectLocation = tappedPoint;
    });
  }
}
