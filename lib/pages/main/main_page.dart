import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_students/Firebase%20Services/user_service.dart';
import 'package:note_app_students/constants/values.dart';

import 'package:note_app_students/pages/main/comp/bottom_nav.dart';
import 'package:note_app_students/pages/main/controller/tabs_controller.dart';
import 'package:note_app_students/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_students/pages/main/drawer/main_drawer.dart';
import 'package:note_app_students/pages/main/tabs/Live/live_stream.dart';
import 'package:note_app_students/pages/main/tabs/chat/chat.dart';
import 'package:note_app_students/pages/main/tabs/subjects/subjects.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> tabNames = ["My Subjects", "Chat","Live Stream"];

  TabsController tabsController = Get.put(TabsController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DController dController = Get.put(DController());

  List<Widget> tabs = [
    const MySubjects(),
    ChatPage(),
    const LiveStreamPage()
  ];

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserService());
    Get.find<UserService>().getUserInfo();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        centerTitle: true,
        backgroundColor: mainColor,
        title: Obx(() => Text(tabNames[tabsController.selectedIndex.value])),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNav(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: Obx(() => tabs[tabsController.selectedIndex.value]),
    );
  }
}
