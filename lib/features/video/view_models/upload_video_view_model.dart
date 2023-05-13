import 'dart:async';
import 'dart:io';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../../users/view_models/user_view_model.dart';
import '../models/video_model.dart';
import '../repo/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;
  var geoHasher = GeoHasher();

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo(
    File video,
    String location,
    String address,
    double longitude,
    double latitude,
    String description,
    List<String> hashTags,
    String url,
    BuildContext context,
  ) async {
    final user = ref.read(authRepo).user;
    final userProfile =
        ref.read(usersProvider(ref.read(authRepo).user!.uid)).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        if (task.metadata != null) {
          await _repository.saveVideo(
            VideoModel(
              id: "",
              title: "제목",
              description: description,
              fileUrl: await task.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
              location: location,
              address: address,
              longitude: longitude,
              latitude: latitude,
              kakaomapId: url.split(".com/")[1],
              geoHash: geoHasher.encode(longitude, latitude, precision: 20),
              hashtag: hashTags,
            ),
          );
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
