import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_students/data/subjects_data.dart';
import 'package:note_app_students/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_students/pages/notes/notes.dart';

class MySubjects extends StatefulWidget {
  const MySubjects({Key? key}) : super(key: key);

  @override
  _MySubjectsState createState() => _MySubjectsState();
}

class _MySubjectsState extends State<MySubjects> {
  DController dController = Get.put(DController());

  List<SubjectData> data = [
    SubjectData("Chemistry", "9,10,11N,12N"),
    SubjectData("Biology", "9,10,11N,12N"),
    SubjectData("Physics", "9,10,11N,12N"),
    SubjectData("History", "9,10,11S,12S"),
    SubjectData("Geograpy", "9,10,11S,12S"),
    SubjectData("English", "9,10,11N,12N,11S,12N"),
    SubjectData("Amharic", "9,10,11N,12N,11S,12S"),
    SubjectData("SAT", "9,10,11N,12N,11S, 12S"),
    SubjectData("Economics", "9,10,11S,12S"),
    SubjectData("Bussiness", "9,10,11S,12S"),
  ];
  List<SubjectData> newData = [];
  @override
  void initState() {
    
    super.initState();
    data.forEach((subject) {
      if (subject.classes.contains(dController.myInfo.value.grade)) {
        newData.add(subject);
      }
    });
    setState(() {
      
    });
    
  }

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      itemCount: newData.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Get.to(() => NotesPage(subject: newData[index].name));
        },
        leading: Image.asset("assets/subject.png"),
        title: Text(newData[index].name),
      ),
    );
  }
}
