import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future<void> follwoUser(String uid1, String uid2) async {
    final query = _db.collection("following").doc("${uid1}000$uid2");
    final following = await query.get();
    if (!following.exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      await query.delete();
    }
  }

  Future<bool> isFollowUser(String uid1, String uid2) async {
    final query = _db.collection("following").doc("${uid1}000$uid2");
    final follow = await query.get();
    return follow.exists;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchThumbnail(String uid) async {
    final query = await _db
        .collection("users")
        .doc(uid)
        .collection('videos')
        .orderBy('createdAt', descending: true)
        .get();
    return query;
  }
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
