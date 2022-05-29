import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_students/Firebase%20Services/user_service.dart';
import 'package:note_app_students/comp/msg_snack.dart';
import 'package:note_app_students/constants/values.dart';
import 'package:note_app_students/pages/RegisterationPage/comp/btn.dart';
import 'package:note_app_students/pages/RegisterationPage/comp/input.dart';
import 'package:note_app_students/pages/RegisterationPage/controller/signuplogin_controller.dart';

class MoreInfo extends StatefulWidget {
  const MoreInfo({Key? key}) : super(key: key);

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  GlobalKey<FormState> _moreInfoKey = GlobalKey<FormState>();
  TextEditingController nameTC = TextEditingController();
  TextEditingController gradeTC = TextEditingController();

  SLController slController = Get.put(SLController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Center(
          child: Form(
            key: _moreInfoKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 40, left: 40),
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  const Text("More Info",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () async {
                      XFile? imageXFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (imageXFile == null) {
                        MSGSnack msgSnack = MSGSnack(
                            title: "Note!",
                            msg: "Image is not selected",
                            color: Colors.white);
                        msgSnack.show();
                      } else {
                        slController.setProfileImage(imageXFile.path);
                      }
                    },
                    child: Obx(
                      () => slController.profileImage.value == ""
                          ? CircleAvatar(
                              radius: 45,
                              backgroundColor: mainColor,
                              child: Icon(
                                Icons.account_circle,
                                color: whiteColor,
                                size: 90,
                              ))
                          : CircleAvatar(
                              radius: 45,
                              backgroundImage: FileImage(
                                  File(slController.profileImage.value)),
                            ),
                    ),
                  ),
                  Input(
                      textEditingController: nameTC,
                      hinttxt: "Abebe Chala",
                      title: "Name",
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 15,
                  ),
                  Input(
                      textEditingController: gradeTC,
                      hinttxt: "12S",
                      title: "Grade",
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 15,
                  ),
                  BTN(
                      text: "Submit",
                      action: () {
                        if (_moreInfoKey.currentState!.validate()) {
                          if (slController.profileImage.value != "") {
                            Get.find<UserService>().saveUserInfo(
                              nameTC.text,
                              gradeTC.text,
                              context,
                              File(slController.profileImage.value)
                            );
                          }
                        }else{

                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
