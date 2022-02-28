class MyInfo {
  final String uid, name, grade;

  MyInfo(this.uid, this.name, this.grade);

  Map<String, Object?> toFirebaseMap(MyInfo myInfo) {
    return <String, Object>{
      "uid": myInfo.uid,
      "name": myInfo.name,
      "grade": myInfo.grade,
    };
  }

  MyInfo.fromFirebaseMap(Map<dynamic, dynamic> data)
      : uid = data['uid'].toString(),
        name = data['name'].toString(),
        grade = data["grade"].toString();
}
