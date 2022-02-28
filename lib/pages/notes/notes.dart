import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_students/constants/values.dart';
import 'package:note_app_students/model/note.dart';
import 'package:note_app_students/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_students/pages/notes/comp/note_item.dart';
import 'package:note_app_students/pages/notes/controller/notes_controller.dart';

class NotesPage extends StatelessWidget {
  String subject;
  NotesPage({Key? key, required this.subject}) : super(key: key);

  DatabaseReference notesRef = FirebaseDatabase.instance.ref().child("Notes");

  NoteController noteController = Get.put(NoteController());

  DController dController = Get.put(DController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text("Grade $subject"),
      ),
      body: StreamBuilder(
        stream: notesRef.onValue,
        builder: (context, snapshot) {
          noteController.setIsLoading(true);
          List<Note> noteList = [];
          if (snapshot.hasData) {
            final notesdata = Map<String, Object>.from(
                (snapshot.data as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
            notesdata.forEach((key, value) {
              final note =
                  Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);
              final noteModel = Note.fromFirebaseMap(note);
              print(note["grade"].toString().toLowerCase() +
                  "&" +
                  dController.myInfo.value.grade.toLowerCase());
              if (note["grade"].toString().toLowerCase() ==
                  dController.myInfo.value.grade.toLowerCase()) {
                if (note["subject"].toString().toLowerCase() ==
                    subject.toLowerCase()) {
                  noteList.add(noteModel);
                }
              }
            });
            noteList.sort(((a, b) => a.nid.compareTo(b.nid)));
            noteController.setIsLoading(false);
          }
          return Obx(
            () => noteController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  )
                : ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (context, index) =>
                        NoteItem(note: noteList[index])),
          );
        },
      ),
    );
  }
}
