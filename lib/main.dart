import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ungwinshopping/states/authen.dart';
import 'package:ungwinshopping/states/create_account.dart';
import 'package:ungwinshopping/states/my_service.dart';
import 'package:ungwinshopping/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (BuildContext context) => Authen(),
  MyConstant.routeCreateAccount: (BuildContext context) => CreateAccount(),
  MyConstant.routeMyService: (BuildContext context) => MyService(),
};

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: MyConstant.routeAuthen,
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
