import 'package:easy_localization/easy_localization.dart';
import 'package:helpme/Screens/Home/home_screen.dart';
import 'package:helpme/Screens/Welcome/welcome_screen.dart';
import 'package:helpme/constants.dart';
import 'package:flutter/material.dart';

import 'components/size_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'EN'), Locale('vi', 'VN')],
        path: 'assets/translations', // <-- change patch to your
        fallbackLocale: Locale('vi', 'VN'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Me App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
