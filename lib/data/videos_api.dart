import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok_flutter/models/video.dart';
import 'demo_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideosAPI {
  VideosAPI();


  Future<List<Video>> getVideoListForUser(String userId) async {
    var cat;
    final dd = await Firestore.instance.collection('users').getDocuments();
    for (var d in dd.documents) {
      final _auth = FirebaseAuth.instance;
      var user = await _auth.currentUser();
      if (user.uid == d.data['id']) {
        cat = d.data['category'];
        print(cat);
      }
    }

    var data = await Firestore.instance.collection("Videos").getDocuments();
    if (data.documents.length == 0) {
      await addDemoData();
    }

    var videoList = <Video>[];
    var videos = await Firestore.instance.collection("Videos").getDocuments();

    videos.documents.forEach((element) async {
      Video video = Video.fromJson(element.data);
      if (video.cat == cat) {
        videoList.add(video);
      }
    });

    return videoList;
  }

  Future<Null> addDemoData() async {
    for (var video in data) {
      await Firestore.instance.collection("Videos").add(video);
    }
  }

  //Working in User System
  Future<bool> removeVideosFromFeed(
      String userId, List<String> videoIds) async {
    await Firestore.instance
        .collection('Users')
        .document(userId)
        .updateData({"videosViewed": FieldValue.arrayUnion(videoIds)});
    return true;
  }

  Future<bool> clearHistory(String userId) async {
    var user =
        await Firestore.instance.collection('Users').document(userId).get();
    var listToRemove = user.data['videosViewed'];
    await Firestore.instance
        .collection('Users')
        .document(userId)
        .updateData({"videosViewed": FieldValue.arrayRemove(listToRemove)});
    return true;
  }
}
