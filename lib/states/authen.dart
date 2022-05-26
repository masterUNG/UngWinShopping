import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungwinshopping/models/user_model.dart';
import 'package:ungwinshopping/utility/my_constant.dart';
import 'package:ungwinshopping/utility/my_dialog.dart';
import 'package:ungwinshopping/widgets/show_button.dart';
import 'package:ungwinshopping/widgets/show_form.dart';
import 'package:ungwinshopping/widgets/show_image.dart';
import 'package:ungwinshopping/widgets/show_text.dart';
import 'package:ungwinshopping/widgets/show_text_button.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool obsecuPassword = true;
  String? phone, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Container(
            decoration: MyConstant().pictureBox(),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              newLogo(constraints),
                              newTitle(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    newPhone(),
                    newPassword(),
                    newForgotPassword(),
                    newButtonLogin(),
                    newCreateAccount()
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Row newCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowText(label: 'ยังไม่มีบัญชี ? '),
        ShowTextButton(
            label: 'สมัครใช้งาน',
            pressFunc: () {
              Navigator.pushNamed(context, MyConstant.routeCreateAccount);
            })
      ],
    );
  }

  Future<void> processCheckAuthen() async {
    String path =
        'https://www.androidthai.in.th/flutter/getUserWhereUser.php?isAdd=true&phone=$phone';
    await Dio().get(path).then((value) {
      if (value.toString() == 'null') {
        MyDialog(context: context).normalDialog(
            title: 'Phone False', subTitle: 'No $phone in my Database');
      } else {
        for (var element in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(element);
          if (password == userModel.password) {
            print('Authen Success');
          } else {
            MyDialog(context: context).normalDialog(
                title: 'Password False',
                subTitle: 'Please Try Again Passowrd salfe');
          }
        }
      }
    });
  }

  ShowButton newButtonLogin() => ShowButton(
        label: 'เข้าสู่ระบบ',
        pressFunc: () {
          if ((phone?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            MyDialog(context: context).normalDialog(
                title: 'Have Space ?', subTitle: 'Please Fill Every Blank');
          } else {
            processCheckAuthen();
          }
        },
      );

  ShowTextButton newForgotPassword() =>
      ShowTextButton(label: 'ลืมรหัสผ่าน ?', pressFunc: () {});

  ShowForm newPassword() {
    return ShowForm(
      obsecu: obsecuPassword,
      subfixIcon: IconButton(
          onPressed: () {
            setState(() {
              obsecuPassword = !obsecuPassword;
            });
          },
          icon: Icon(
            Icons.remove_red_eye,
            color: MyConstant.primary,
          )),
      label: 'รหัสผ่าน',
      iconData: Icons.lock_outline,
      changeFunc: (String string) {
        password = string.trim();
      },
    );
  }

  ShowForm newPhone() {
    return ShowForm(
      label: 'หมายเลข โทร',
      iconData: Icons.phone,
      textInputType: TextInputType.phone,
      changeFunc: (String string) {
        phone = string.trim();
      },
    );
  }

  ShowText newTitle() => ShowText(
        label: 'เข้าสู่ระบบ',
        textStyle: MyConstant().h2Style(),
      );

  SizedBox newLogo(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.25,
      child: ShowImage(),
    );
  }
}
