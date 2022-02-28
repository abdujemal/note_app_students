import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:note_app_students/comp/msg_snack.dart';
import 'package:note_app_students/pages/RegisterationPage/comp/more_info_sheet.dart';
import 'package:note_app_students/pages/RegisterationPage/controller/signuplogin_controller.dart';
import 'package:note_app_students/pages/RegisterationPage/registration_page.dart';
import 'package:note_app_students/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_students/pages/note_viewer/controller/pdf_viewer_controller.dart';
import 'package:path_provider/path_provider.dart';
import '../model/myinfo.dart';
import '../model/note.dart';
import '../pages/main/main_page.dart';

class UserService extends GetxService {
  SLController slcontroller = Get.put(SLController());

  DController dController = Get.put(DController());

  PVController pvController = Get.put(PVController());

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseDatabase datebase = FirebaseDatabase.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> downloadPDF(String nid) async {
    pvController.setIsDownloading(true);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${nid}.pdf');

    try {
      await storage.ref('Notes/${nid}').writeToFile(downloadToFile);

      pvController.setIsDownloading(false);

      
      pvController.setPdfController(PdfControllerPinch(
          initialPage: 1,
          document: PdfDocument.openFile("${appDocDir.path}/${nid}.pdf")));
      
      pvController.setFilePath("${appDocDir.path}/${nid}.pdf");


      // MSGSnack succesMsg = MSGSnack(
      //     title: "Success!", msg: "Download is completed.", color: Colors.red);

      // succesMsg.show();

      // Get.back();

    } catch (e) {
      pvController.setIsDownloading(false);

      MSGSnack errorMsg =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errorMsg.show();
    }
  }

  getUserInfo() async {
    try {
      DatabaseEvent event = await datebase
          .ref()
          .child("Students")
          .child(auth.currentUser!.uid)
          .once();

      if (event.snapshot.exists) {
        var datas = event.snapshot.value as Map<dynamic, dynamic>;

        print(datas["grade"]);
        dController.setMyInfo(MyInfo.fromFirebaseMap(datas));
        await FirebaseMessaging.instance.subscribeToTopic(datas["grade"]);
      }
    } catch (e) {
      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  saveUserInfo(String name, String grade, BuildContext context) async {
    MyInfo myInfo = MyInfo(auth.currentUser!.uid, name, grade);
    Map<String, Object?> mydata = myInfo.toFirebaseMap(myInfo);
    try {
      slcontroller.setIsLoading(true);

      await datebase
          .ref()
          .child("Students")
          .child(auth.currentUser!.uid)
          .update(mydata);

      slcontroller.setIsLoading(false);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    } catch (e) {
      slcontroller.setIsLoading(false);

      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  saveUserInfoFromDrawer(
      String name, String grade, BuildContext context) async {
    MyInfo myInfo = MyInfo(auth.currentUser!.uid, name, grade);
    Map<String, Object?> mydata = myInfo.toFirebaseMap(myInfo);
    try {
      dController.setIsLoading(true);

      await datebase
          .ref()
          .child("Students")
          .child(auth.currentUser!.uid)
          .update(mydata);

      dController.setIsLoading(false);

      getUserInfo();
    } catch (e) {
      dController.setIsLoading(false);

      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  Future<bool?> doesUserExist() async {
    try {
      final event = await datebase
          .ref()
          .child("Students")
          .child(auth.currentUser!.uid)
          .once();

      if (event.snapshot.exists) return true;
      return false;
    } catch (e) {
      MSGSnack errorMsg =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);
      return null;
    }
  }

  logInWEmailNPW(String email, String password, BuildContext context) async {
    try {
      slcontroller.setIsLoading(true);
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async{
        

        await checkUser(context);
        slcontroller.setIsLoading(false);
      });
    } catch (e) {
      slcontroller.setIsLoading(false);
      MSGSnack errorMSG =
          MSGSnack(color: Colors.red, title: "Error!", msg: e.toString());
      errorMSG.show();
    }
  }

  Future<void> checkUser(context) async {
    final doesuserExist = await doesUserExist();
    if (doesuserExist == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationPage()),
          (route) => false);
    } else {
      if (doesuserExist) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);
      } else {
        Get.bottomSheet(const MoreInfo(), isDismissible: false);
      }
    }
  }

  signUpWEmailNPW(String email, String password, BuildContext context) async {
    try {
      slcontroller.setIsLoading(true);

      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async {
        await checkUser(context);
        slcontroller.setIsLoading(false);
      });
    } catch (e) {
      slcontroller.setIsLoading(false);
      MSGSnack errorMSG =
          MSGSnack(color: Colors.red, title: "Error!", msg: e.toString());
      errorMSG.show();
    }
  }

  signInWGoogleAccount() {}

  forgetPassword(String email, BuildContext context) async {
    try {
      slcontroller.setIsLoading(true);
      await auth.sendPasswordResetEmail(email: email);

      MSGSnack successMSG = MSGSnack(
          title: "Success!",
          msg: "We successfully sent you an email.",
          color: Colors.green);
      successMSG.show();

      slcontroller.setIsLoading(false);
    } catch (e) {
      slcontroller.setIsLoading(false);

      MSGSnack errorMSG =
          MSGSnack(color: Colors.red, title: "Error!", msg: e.toString());
      errorMSG.show();
    }
  }
}
