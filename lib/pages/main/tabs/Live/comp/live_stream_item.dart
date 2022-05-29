import 'package:flutter/material.dart';
import 'package:note_app_students/model/live_stream.dart';

class LiveStreamItem extends StatelessWidget {
  LiveStream liveStream;
  LiveStreamItem({Key? key, required this.liveStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ListTile(
        onTap: () {
          
        },
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              child:
                  CircleAvatar(backgroundImage: NetworkImage(liveStream.t_img)),
            ),
            Positioned(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Live",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ))
          ],
        ),
        title: Text(liveStream.title),
        subtitle: Text(liveStream.t_name),
        trailing: Row(
          children: [
            const Icon(Icons.person),
            Text(liveStream.numOfUser),
          ],
        ),
      ),
    );
  }
}
