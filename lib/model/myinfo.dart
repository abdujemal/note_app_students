class MyInfo {
  final String uid, name, grade, img_url;

  MyInfo(this.uid, this.name, this.grade, this.img_url);

  Map<String, Object?> toFirebaseMap(MyInfo myInfo) {
    return <String, Object>{
      "uid": myInfo.uid,
      "name": myInfo.name,
      "grade": myInfo.grade,
      "img_url": myInfo.img_url
    };
  }

  MyInfo.fromFirebaseMap(Map<dynamic, dynamic> data)
      : uid = data['uid'].toString(),
        name = data['name'].toString(),
        grade = data["grade"].toString(),
        img_url = data['img_url'].toString();
}
