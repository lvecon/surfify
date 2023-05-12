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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchFollowers(String uid) async {
    final query = _db.collection("users").doc(uid).collection('followers');
    return query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchFollowings(
      String uid) async {
    final query = _db.collection("users").doc(uid).collection('followings');
    return query.get();
  }

  Future<void> followUser(String uid1, String uid2) async {
    final query = _db.collection("followings").doc("${uid1}000$uid2");
    final following = await query.get();
    if (!following.exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
      await _db
          .collection("users")
          .doc(uid1)
          .collection("followings")
          .doc(uid2)
          .set({"uid": uid2});
      await _db
          .collection("users")
          .doc(uid2)
          .collection("followers")
          .doc(uid1)
          .set({"uid": uid1});
    } else {
      await query.delete();
      await _db
          .collection("users")
          .doc(uid1)
          .collection("followings")
          .doc(uid2)
          .delete();
      await _db
          .collection("users")
          .doc(uid2)
          .collection("followers")
          .doc(uid1)
          .delete();
    }
  }

  Future<bool> isFollowUser(String uid1, String uid2) async {
    final query = _db.collection("followings").doc("${uid1}000$uid2");
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
