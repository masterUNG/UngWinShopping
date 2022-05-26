import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyConstant {
  //field

  static String pathApiReadAllProvince =
      'https://www.androidthai.in.th/flutter/getAllprovinces.php';
  static String pathApiReadAmphurByProvinceId =
      'https://www.androidthai.in.th/flutter/getAmpByProvince.php?isAdd=true&province_id=';
  static String pathApiReadDistriceByAmphureId =
      'https://www.androidthai.in.th/flutter/getDistriceByAmphure.php?isAdd=true&amphure_id=';

  static Color primary = const Color.fromARGB(255, 95, 9, 188);
  static Color dark = const Color(0xff133c29);
  static Color bgColor = const Color(0xffded02a);

  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeMyService = '/myService';

  //method
  BoxDecoration corveBox() => BoxDecoration(
        border: Border.all(color: MyConstant.dark),
        borderRadius: BorderRadius.circular(30),
      );

  BoxDecoration basicBox() => BoxDecoration(color: bgColor.withOpacity(0.5));

  BoxDecoration gradianBox() => BoxDecoration(
        gradient: RadialGradient(
            colors: [Colors.white, bgColor],
            radius: 1.0,
            center: const Alignment(0, -0.2)),
      );

  BoxDecoration pictureBox() => const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
      );

  TextStyle h1Style() => GoogleFonts.kodchasan(
          textStyle: TextStyle(
        fontSize: 48,
        color: dark,
        fontWeight: FontWeight.bold,
      ));

  TextStyle h2Style() => GoogleFonts.kodchasan(
          textStyle: TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      ));

  TextStyle h3Style() => GoogleFonts.kodchasan(
          textStyle: TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      ));

  TextStyle h3ActionStyle() => GoogleFonts.kodchasan(
          textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.pink,
        fontWeight: FontWeight.w500,
      ));
} // end Class