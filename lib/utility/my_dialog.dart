// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ungwinshopping/utility/my_constant.dart';
import 'package:ungwinshopping/widgets/show_image.dart';
import 'package:ungwinshopping/widgets/show_text.dart';
import 'package:ungwinshopping/widgets/show_text_button.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> normalDialog(
      {required String title, required String subTitle}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: SizedBox(
            width: 80,
            child: ShowImage(),
          ),
          title: ShowText(
            label: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(label: subTitle),
        ),
        actions: [
          ShowTextButton(
              label: 'OK',
              pressFunc: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
