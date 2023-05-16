import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<void> deleteVideo(VideoModel videoModel) async {
    print(videoModel.id);
    await _db.collection("videos").doc(videoModel.id).delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(3);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideosHome({
    String? hash,
    int? lastItemCreatedAt,
  }) {
    if (hash == null) {
      return _db.collection('locations').get();
    } else {
      final query = _db
          .collection('locations')
          .doc(hash.substring(0, 5))
          .collection('sub')
          .doc(hash.substring(5, 9))
          .collection('videos')
          .orderBy("createdAt", descending: true);
      if (lastItemCreatedAt == null) {
        return query.get();
      } else {
        return query.startAfter([lastItemCreatedAt]).get();
      }
    }
  }

  //유저랑 해시태그
  Future<QuerySnapshot<Map<String, dynamic>>>? fetchVideoswithBoth({
    List<String>? searchConditions,
    int? lastItemCreatedAt,
  }) {
    if (searchConditions == null) {
      return _db.collection('hashtags').get().then((snapshot) => snapshot);
    } else {
      Query<Map<String, dynamic>> query = _db
          .collection('hashtags')
          .doc(searchConditions[1])
          .collection('videos');

      if (lastItemCreatedAt == null) {
        return query.get().then((snapshot) => snapshot);
      } else {
        return query
            .startAfter([lastItemCreatedAt])
            .get()
            .then((snapshot) => snapshot);
      }
    }
  }

  //해시태그만
  Future<QuerySnapshot<Map<String, dynamic>>>? fetchVideosWithHashTags({
    List<String>? searchConditions,
    int? lastItemCreatedAt,
  }) {
    if (searchConditions == null) {
      return _db.collection('hashtags').get().then((snapshot) => snapshot);
    } else {
      Query<Map<String, dynamic>> query = _db
          .collection('hashtags')
          .doc(searchConditions[0])
          .collection('videos');

      if (lastItemCreatedAt == null) {
        return query.get().then((snapshot) => snapshot);
      } else {
        return query
            .startAfter([lastItemCreatedAt])
            .get()
            .then((snapshot) => snapshot);
      }
    }
  }

  //유저만 검색
  Future<QuerySnapshot<Map<String, dynamic>>>? fetchVideoswithUser({
    List<String>? searchConditions,
    int? lastItemCreatedAt,
  }) async {
    if (searchConditions == null) {
      return _db.collection('hashtags').get().then((snapshot) => snapshot);
    } else {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('users')
          .where('name', isEqualTo: searchConditions[0])
          .get();
      final List<DocumentSnapshot<Map<String, dynamic>>> documents =
          snapshot.docs;
      late Query<Map<String, dynamic>> query;

      if (documents.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> document = documents[0];
        final String uid = (document.data()!['uid'] as String?) ?? '';

        query = _db.collection('users').doc(uid).collection('videos');
      } else {
        query = _db.collection('users').doc('').collection('videos');
      }

      if (lastItemCreatedAt == null) {
        return query.get().then((snapshot) => snapshot);
      } else {
        return query
            .startAfter([lastItemCreatedAt])
            .get()
            .then((snapshot) => snapshot);
      }
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchLocations({
    String? hash,
  }) {
    if (hash == null) {
      return _db.collection("location").get();
    } else {
      final query = _db
          .collection('locations')
          .doc(hash.substring(0, 5))
          .collection('sub');
      return query.get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();

    if (!like.exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      await query.delete();
    }
  }

  Future<bool> isLikeVideo(String videoId, String userId) async {
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();
    return like.exists;
  }
}

final videosRepo = Provider((ref) => VideosRepository());
