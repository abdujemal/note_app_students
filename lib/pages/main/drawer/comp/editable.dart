import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_students/pages/RegisterationPage/comp/input.dart';

import '../../../../constants/values.dart';
import '../controller/drawer_controller.dart';

class Editable extends StatelessWidget {
  TextEditingController nameTC = TextEditingController();
  TextEditingController gradeTC = TextEditingController();
  GlobalKey<FormState> accountKey = GlobalKey<FormState>();

  Editable(
      {Key? key,
      required this.nameTC,
      required this.gradeTC,
      required this.accountKey,
      })
      : super(key: key);

  DController dController = Get.put(DController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SingleChildScrollView(
        child: Form(
          key: accountKey,
          child: Column(
            children: [
              Input(
                  textEditingController: nameTC,
                  hinttxt: "Abebe Chala",
                  title: "Name",
                  keyboardType: TextInputType.name),
              const SizedBox(
                height: 15,
              ),
              Input(
                  textEditingController: gradeTC,
                  hinttxt: "12N",
                  title: "Grade",
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 15,
              ),
              
              Obx(()=>
                 dController.isLoading.value ?
                 CircularProgressIndicator(color: mainColor,) :
                 const SizedBox()
              ),
              const SizedBox(height: 400)
            ],
          ),
        ),
      ),
    );
  }
}
