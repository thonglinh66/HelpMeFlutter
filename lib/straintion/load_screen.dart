import 'package:flutter/material.dart';
import 'package:helpme/constants.dart';

class ProcessDialog {
  static ProcessDialog _instance = new ProcessDialog.internal();
  static bool _isLoading = false;
  ProcessDialog.internal();
  factory ProcessDialog() => _instance;
  static BuildContext _context;

  static void closeLoadingDialog() {
    if (_isLoading) {
      Navigator.of(_context).pop();
      _isLoading = false;
    }
  }

  static void showLoadingDialog(BuildContext context) async {
    _context = context;
    _isLoading = true;
    await showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                ),
              )
            ],
          );
        });
  }
}
