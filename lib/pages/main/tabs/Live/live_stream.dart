import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:note_app_students/model/live_stream.dart';
import 'package:note_app_students/pages/main/tabs/Live/comp/live_stream_item.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("LiveStream");
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
                LiveStream liveStream = LiveStream.fromFirebaseMap(value);
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
                      LiveStreamItem(liveStream: list[index]))
              : const Text("No Live Stream");
        });
  }
}
