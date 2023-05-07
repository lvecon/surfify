import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideosHereRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

final videosRepo = Provider((ref) => VideosHereRepository());
