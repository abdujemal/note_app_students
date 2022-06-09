import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_students/model/live_stream.dart';
import 'package:note_app_students/pages/main/tabs/Live/comp/live_stream_item.dart';

import '../../../../Firebase Services/user_service.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("LiveStream");

  var userService = Get.put(UserService());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          List<LiveStream> list = [];
          if (snapshot.hasData) {
            if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
              final data = Map<dynamic, dynamic>.from(
                  (snapshot.data as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);
              data.forEach((key, value) {
                
                final liveStreamData = Map<dynamic, dynamic>.from(
                            value as Map<dynamic, dynamic>);
                LiveStream liveStream = LiveStream.fromFirebaseMap(liveStreamData);
                list.add(liveStream);
              });
            } else {
              return const Center(child: Text("No Live Stream"));
            }
          }
          return list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      LiveStreamItem(liveStream: list[index], userService: userService,))
              : const Center(child: Text("No Live Stream"));
        });
  }
}
