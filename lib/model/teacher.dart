class Teacher {
  String classes, name, uid, subject;
  Teacher(this.classes, this.name, this.uid, this.subject);

  Teacher.fromFireBaseMap(Map<dynamic, dynamic> data)
      : name = data["name"],
        classes = data["classes"],
        uid = data["uid"],
        subject = data["subject"];

  Map<String, Object> toFirebaseMap(Teacher teacher) {
    return <String, Object>{
      "name": teacher.name,
      "classes": teacher.classes,
      "uid": teacher.uid,
      "subject": teacher.subject 
    };
  }
}
