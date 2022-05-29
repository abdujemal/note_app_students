class LiveStream {
  String title, numOfUser, lid, tid, t_name, t_img;
  LiveStream(
      this.title, this.numOfUser, this.lid, this.tid, this.t_name, this.t_img);

  toFirebaseMap(LiveStream liveStream) {
    return {
      "title": liveStream.title,
      "numOfUser": liveStream.numOfUser,
      "lid": liveStream.lid,
      "tid": liveStream.tid,
      "t_name": liveStream.t_name,
      "t_img": t_img
    };
  }

  LiveStream.fromFirebaseMap(Map<dynamic, dynamic> data)
      : tid = data["tid"],
        numOfUser = data["numOfUser"],
        lid = data["lid"],
        t_name = data["t_name"],
        title = data["title"],
        t_img = data['t_img'];
}
