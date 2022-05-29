import 'package:flutter/material.dart';
import 'package:note_app_students/model/live_chat.dart';

class LiveChatItem extends StatelessWidget {
  LiveChat liveChat;
  LiveChatItem({Key? key, required this.liveChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(liveChat.img_url),
          ),
          const SizedBox(width: 20,),
          Row(
            children: [
              Text(liveChat.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white)),
              const SizedBox(height: 10),
              Text(liveChat.text, style: const TextStyle(fontSize: 18, color: Colors.white),)
            ],
            )
        ],
      ),
    );
  }
}
