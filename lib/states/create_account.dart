import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungwinshopping/models/amphur_model.dart';
import 'package:ungwinshopping/models/districe_model.dart';
import 'package:ungwinshopping/models/province_model.dart';
import 'package:ungwinshopping/utility/my_constant.dart';
import 'package:ungwinshopping/utility/my_dialog.dart';
import 'package:ungwinshopping/widgets/show_button.dart';
import 'package:ungwinshopping/widgets/show_form.dart';
import 'package:ungwinshopping/widgets/show_icon_button.dart';
import 'package:ungwinshopping/widgets/show_image.dart';
import 'package:ungwinshopping/widgets/show_progress.dart';
import 'package:ungwinshopping/widgets/show_text.dart';
import 'package:ungwinshopping/widgets/show_text_button.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var provinceModels = <ProvinceModel>[];
  var indexProvinces = <int>[];
  bool load = true;
  int? indexProcince;

  bool loadAmphur = true;
  var amphurModels = <AmphurModel>[];
  var indexAmphurs = <int>[];
  int? indexAmphur;

  bool loadDistric = true;
  var districModels = <DistricModel>[];
  var indexDistrics = <int>[];
  int? indexDistric;

  bool accept = false;

  String? nameShop,
      email,
      password,
      phone,
      lindId,
      idAddress,
      villate,
      soi,
      streed,
      introduct = '';

  File? file;

  @override
  void initState() {
    super.initState();
    readAllProvince();
  }

  Future<void> processCreateAccount() async {
    if ((nameShop?.isEmpty ?? true) ||
        (email?.isEmpty ?? true) ||
        (password?.isEmpty ?? true) ||
        (phone?.isEmpty ?? true) ||
        (lindId?.isEmpty ?? true) ||
        (idAddress?.isEmpty ?? true) ||
        (villate?.isEmpty ?? true) ||
        (soi?.isEmpty ?? true) | (streed?.isEmpty ?? true)) {
      MyDialog(context: context).normalDialog(
          title: 'Have Space ?', subTitle: 'Please Fill Every Blank');
    } else if ((indexProcince == null) ||
        (indexAmphur == null) ||
        (indexDistric == null)) {
      MyDialog(context: context).normalDialog(
          title: 'Choose ไม่ครบ',
          subTitle: 'โปรดเลือก จังหวัด, อำเภอ และ ตำบล');
    } else if (accept) {
      processInsertNewUserToServer();
    } else {
      MyDialog(context: context).normalDialog(
          title: 'ยังไม่ยอมรับ เงื่อนไข',
          subTitle: 'กรุณายอมรับเงิื่อนไขด้วยครับ');
    }
  }

  Future<void> processInsertNewUserToServer() async {
    String path =
        'https://www.androidthai.in.th/flutter/insertUser.php?isAdd=true&name=$nameShop&phone=$phone&password=$password';
    await Dio().get(path).then((value) => Navigator.pop(context));
  }

  Future<void> readDistriceByAmphureId({required String amphureId}) async {
    String path = '${MyConstant.pathApiReadDistriceByAmphureId}$amphureId';

    if (districModels.isNotEmpty) {
      loadDistric = true;
      districModels.clear();
      indexDistrics.clear();
      indexDistric = null;
    }

    await Dio().get(path).then((value) {
      int index = 0;
      for (var element in json.decode(value.data)) {
        DistricModel districModel = DistricModel.fromMap(element);
        districModels.add(districModel);
        indexDistrics.add(index);
        index++;
      }
      loadDistric = false;
      setState(() {});
    });
  }

  Future<void> readAmphurByProvinceId({required String provinceId}) async {
    String path = '${MyConstant.pathApiReadAmphurByProvinceId}$provinceId';

    if (amphurModels.isNotEmpty) {
      amphurModels.clear();
      indexAmphurs.clear();
      indexAmphur = null;
    }

    await Dio().get(path).then((value) {
      int index = 0;
      for (var element in json.decode(value.data)) {
        AmphurModel amphurModel = AmphurModel.fromMap(element);
        amphurModels.add(amphurModel);
        indexAmphurs.add(index);
        index++;
      }
      loadAmphur = false;
      setState(() {});
    });
  }

  Future<void> readAllProvince() async {
    String path = MyConstant.pathApiReadAllProvince;
    await Dio().get(path).then((value) {
      int index = 0;
      for (var element in json.decode(value.data)) {
        ProvinceModel model = ProvinceModel.fromMap(element);
        provinceModels.add(model);
        indexProvinces.add(index);
        index++;
      }
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ShowIconButton(
              iconData: Icons.cloud_upload_outlined,
              tapFunc: () {
                processCreateAccount();
              })
        ],
        title: ShowText(
          label: 'สมัครสมาชิก',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: ListView(
          children: [
            newTitle(title: 'Logo ร้าน :'),
            newImageShop(),
            newTitle(title: 'ข้อมูลทั้วไป :'),
            newCenter(
                widget: ShowForm(
                    label: 'ชื่อร้าน :',
                    iconData: Icons.home_outlined,
                    changeFunc: (String string) {
                      nameShop = string.trim();
                    })),
            newCenter(
              widget: ShowForm(
                label: 'Email :',
                iconData: Icons.email_outlined,
                changeFunc: (String string) {
                  email = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                label: 'Password :',
                iconData: Icons.lock_outline,
                changeFunc: (String string) {
                  password = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                textInputType: TextInputType.phone,
                label: 'เบอร์โทร :',
                iconData: Icons.phone,
                changeFunc: (String string) {
                  phone = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                label: 'Lind ID:',
                iconData: Icons.line_style,
                changeFunc: (String string) {
                  lindId = string.trim();
                },
              ),
            ),
            newTitle(title: 'ข้อมูลที่อยู่ :'),
            newCenter(
              widget: ShowForm(
                label: 'บ้านาเลขที่ / อาคาร :',
                iconData: Icons.house,
                changeFunc: (String string) {
                  idAddress = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                label: 'หมู่บ้าน :',
                iconData: Icons.factory,
                changeFunc: (String string) {
                  villate = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                label: 'ซอย :',
                iconData: Icons.strikethrough_s_sharp,
                changeFunc: (String string) {
                  soi = string.trim();
                },
              ),
            ),
            newCenter(
              widget: ShowForm(
                label: 'ถนน :',
                iconData: Icons.landscape,
                changeFunc: (String string) {
                  streed = string.trim();
                },
              ),
            ),
            load ? const ShowProgress() : newCenter(widget: dropProvince()),
            indexProcince == null
                ? const SizedBox()
                : loadAmphur
                    ? const ShowProgress()
                    : newCenter(widget: dropAmphur()),
            indexAmphur == null
                ? const SizedBox()
                : newCenter(widget: dropDistrice()),
            newCenter(
              widget: ShowForm(
                  label: 'ผู้แนะนำ :',
                  iconData: Icons.face,
                  changeFunc: (String string) {}),
            ),
            newCenter(widget: newAccept()),
            newCenter(
                widget: ShowButton(
                    label: 'สมัครใช้งาน',
                    pressFunc: () {
                      processCreateAccount();
                    })),
            const SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  Container newAccept() {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: const ShowText(
            label: 'ยอมรับ ข้อกำหนด การใช้งาน และ นโยบายความเป็น ส่วนตัว'),
        value: accept,
        onChanged: (value) {
          accept = value!;
          setState(() {});
        },
      ),
    );
  }

  Widget dropDistrice() => Container(
        padding: const EdgeInsets.only(left: 32),
        margin: const EdgeInsets.only(top: 16),
        decoration: MyConstant().corveBox(),
        width: 270,
        height: 40,
        child: DropdownButton<dynamic>(
          underline: const SizedBox(),
          hint: const ShowText(label: 'โปรดเลือกตำบล และ ZipCode'),
          value: indexDistric,
          items: indexDistrics
              .map(
                (e) => DropdownMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowText(label: districModels[e].name_th),
                      ShowText(label: districModels[e].zip_code),
                    ],
                  ),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (value) {
            indexDistric = value;
            setState(() {});
          },
        ),
      );

  Widget dropAmphur() => Container(
        padding: const EdgeInsets.only(left: 32),
        margin: const EdgeInsets.only(top: 16),
        decoration: MyConstant().corveBox(),
        width: 270,
        height: 40,
        child: DropdownButton<dynamic>(
          underline: const SizedBox(),
          hint: const ShowText(label: 'โปรดเลือกอำเภอ'),
          value: indexAmphur,
          items: indexAmphurs
              .map(
                (e) => DropdownMenuItem(
                  child: ShowText(label: amphurModels[e].name_th),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (value) {
            indexAmphur = value;
            readDistriceByAmphureId(amphureId: amphurModels[indexAmphur!].id);
            setState(() {});
          },
        ),
      );

  Widget dropProvince() => Container(
        padding: const EdgeInsets.only(left: 32),
        margin: const EdgeInsets.only(top: 16),
        decoration: MyConstant().corveBox(),
        width: 250,
        height: 40,
        child: DropdownButton<dynamic>(
          underline: const SizedBox(),
          hint: const ShowText(label: 'โปรดเลือกจังหวัด'),
          value: indexProcince,
          items: indexProvinces
              .map(
                (e) => DropdownMenuItem(
                  child: ShowText(label: provinceModels[e].name_th),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (value) {
            loadAmphur = true;
            indexProcince = value;
            readAmphurByProvinceId(
                provinceId: provinceModels[indexProcince!].id);
            setState(() {});
          },
        ),
      );

  Row newCenter({required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget,
      ],
    );
  }

  Future<void> takePhoto({required ImageSource imageSource}) async {
    var result = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (result != null) {
      file = File(result.path);
      setState(() {});
    }
  }

  Future<void> dialogChoosePhoto() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: const SizedBox(
            width: 80,
            child: ShowImage(
              path: 'images/shop.png',
            ),
          ),
          title: ShowText(
            label: 'Take Photo',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: const ShowText(label: 'Please tab Camera or Gallery'),
        ),
        actions: [
          ShowTextButton(
            label: 'Camera',
            pressFunc: () {
              Navigator.pop(context);
              takePhoto(imageSource: ImageSource.camera);
            },
          ),
          ShowTextButton(
            label: 'Gallery',
            pressFunc: () {
              Navigator.pop(context);
              takePhoto(imageSource: ImageSource.gallery);
            },
          ),
          ShowTextButton(
            label: 'Cancel',
            pressFunc: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Row newImageShop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 250,
          height: 250,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: file == null
                    ? ShowImage(
                        path: 'images/shop.png',
                      )
                    : Image.file(file!),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ShowIconButton(
                  iconData: Icons.add_a_photo_outlined,
                  tapFunc: () {
                    dialogChoosePhoto();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding newTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: ShowText(
        label: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }
}
