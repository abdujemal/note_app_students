import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:note_app_students/Firebase%20Services/user_service.dart';
import 'package:note_app_students/model/live_stream.dart';
import 'package:note_app_students/src/pages/call.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveStreamItem extends StatelessWidget {
  LiveStream liveStream;
  UserService userService;
  LiveStreamItem(
      {Key? key, required this.liveStream, required this.userService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ListTile(
        onTap: () async {
          await userService.joinLiveStream(
              liveStream.lid, liveStream.numOfUser);

          await [Permission.microphone, Permission.camera].request();
          // push video page with given channel name
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallPage(
                  channelName: liveStream.lid, role: ClientRole.Audience),
            ),
          );
        },
        leading: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CircleAvatar(
                radius: 27,
                backgroundColor: Colors.red,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(liveStream.t_img)),
              ),
            ),
            Positioned(
                right: 15,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2)),
                  child: const Text(
                    "Live",
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ))
          ],
        ),
        title: Text(liveStream.title),
        subtitle: Text(liveStream.t_name),
        trailing: SizedBox(
          width: 50,
          child: Row(
            children: [
              const Icon(Icons.person),
              Text(liveStream.numOfUser),
            ],
          ),
        ),
      ),
    );
  }
}
