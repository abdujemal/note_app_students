import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_students/constants/values.dart';
import 'package:note_app_students/model/teacher.dart';
import 'package:note_app_students/pages/AddChat/controller/add_chat_controller.dart';
import 'package:note_app_students/pages/chat_detail/chat_detail.dart';

class AddChat extends StatefulWidget {
  const AddChat({Key? key}) : super(key: key);

  @override
  _AddChatState createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  DatabaseReference chatRef = FirebaseDatabase.instance.ref().child("Teachers");
  ACControlelr acControlelr = Get.put(ACControlelr());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Start Chat"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: chatRef.onValue,
          builder: (context, snapshot) {
            final List<Teacher> teacherList = [];
            acControlelr.setIsLoading(true);
            if (snapshot.hasData) {
              final data = Map<String, Object>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);

              data.forEach((key, value) {
                final studentdata =
                    Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);
                final teacherModel = Teacher.fromFireBaseMap(studentdata);
                teacherList.add(teacherModel);
              });
              acControlelr.setIsLoading(false);
            }
            return acControlelr.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(color: mainColor),
                  )
                : ListView.builder(
                    itemCount: teacherList.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        Get.to(() => ChatDetail(tid: teacherList[index].uid));
                      },
                      leading: Icon(Icons.account_circle),
                      title: Text(teacherList[index].name),
                      subtitle: Text("I teach ${teacherList[index].classes}"),
                      trailing: Chip(
                          label: Text("Subject ${teacherList[index].subject}")),
                    ),
                  );
          }),
    );
  }
}
