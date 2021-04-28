import 'package:flutter/material.dart';
import 'package:helpme/Screens/List/components/list_body.dart';
import 'package:helpme/components/coustom_bottom_nav_bar.dart';
import 'package:helpme/components/enums.dart';
import 'package:helpme/model/service.dart';

import 'components/profile_body.dart';

class ServieProfileScreen extends StatefulWidget {
  final ServiceModel serviceModel;
  final int index;
  ServieProfileScreen({
    Key key,
    @required this.serviceModel,
    this.index,
  }) : super(key: key);
  @override
  _ServieProfileScreenState createState() =>
      _ServieProfileScreenState(serviceModel, index);
}

class _ServieProfileScreenState extends State<ServieProfileScreen> {
  ServiceModel serviceModel;
  int index;
  _ServieProfileScreenState(this.serviceModel, this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ServiceProfilePage(serviceModel: serviceModel, index: index),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
