import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:01.000",
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1",
      `/tmp/${snapshot.id}.jpg`,
    ]);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    await file.makePublic();
    await snapshot.ref.update({
      thumbnailUrl: file.publicUrl(),
      id: snapshot.id,
    });

    const db = admin.firestore();

    await db
      .collection("users")
      .doc(video.creatorUid)
      .update({
        surfingPoints: admin.firestore.FieldValue.increment(1),
      });

    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({
        thumbnailUrl: file.publicUrl(),
        videoId: snapshot.id,
        createdAt: video.createdAt,
      });

    await db
      .collection("locations")
      .doc(video.geoHash.slice(0, 5))
      .collection("sub")
      .doc(video.geoHash.slice(5, 9))
      .set({
        geoHash: video.geoHash,
        latitude: video.latitude,
        longitude: video.longitude,
      });

    await db
      .collection("locations")
      .doc(video.geoHash.slice(0, 5))
      .collection("sub")
      .doc(video.geoHash.slice(5, 9))
      .collection("videos")
      .add({
        title: video.title,
        description: video.description,
        fileUrl: video.fileUrl,
        thumbnailUrl: file.publicUrl(),
        creatorUid: video.creatorUid,
        likes: video.likes,
        comments: video.comments,
        createdAt: video.createdAt,
        creator: video.creator,
        id: snapshot.id,
        address: video.address,
        location: video.location,
        longitude: video.longitude,
        latitude: video.latitude,
        kakaomapId: video.kakaomapId,
        geoHash: video.geoHash,
        hashtag: video.hashtag,
      });

    for (let i = 0; i < video.hashtag.length; i++) {
      await db
        .collection("hashtags")
        .doc(video.hashtag[i])
        .collection("videos")
        .add({
          title: video.title,
          description: video.description,
          fileUrl: video.fileUrl,
          thumbnailUrl: file.publicUrl(),
          creatorUid: video.creatorUid,
          likes: video.likes,
          comments: video.comments,
          createdAt: video.createdAt,
          creator: video.creator,
          id: snapshot.id,
          address: video.address,
          location: video.location,
          longitude: video.longitude,
          latitude: video.latitude,
          kakaomapId: video.kakaomapId,
          geoHash: video.geoHash,
          hashtag: video.hashtag,
        });
    }
  });

export const onFollowCreated = functions.firestore
  .document("followings/{followId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [userIdA, userIdB] = snapshot.id.split("000");
    await db
      .collection("users")
      .doc(userIdB)
      .update({
        follower: admin.firestore.FieldValue.increment(1),
      });
    await db
      .collection("users")
      .doc(userIdA)
      .update({
        following: admin.firestore.FieldValue.increment(1),
      });
  });

export const onFollowRemoved = functions.firestore
  .document("followings/{followId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [userIdA, userIdB] = snapshot.id.split("000");
    await db
      .collection("users")
      .doc(userIdB)
      .update({
        follower: admin.firestore.FieldValue.increment(-1),
      });
    await db
      .collection("users")
      .doc(userIdA)
      .update({
        following: admin.firestore.FieldValue.increment(-1),
      });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(1),
      });
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(-1),
      });
  });

export const onCommentCreated = functions.firestore
  .document("videos/{videoId}/comments/{commentsId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const videoId = context.params.videoId;
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        comments: admin.firestore.FieldValue.increment(1),
      });

    await db
      .collection("videos")
      .doc(videoId)
      .collection("comments")
      .doc(snapshot.id)
      .update({
        commentId: snapshot.id,
      });
  });

export const onCommentRemoved = functions.firestore
  .document("videos/{videoId}/comments/{commentsId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const videoId = context.params.videoId;
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        comments: admin.firestore.FieldValue.increment(-1),
      });
  });

export const onMessageCreated = functions.firestore
  .document("users/{userId}/message/{messageId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const userId = context.params.userId;
    await db
      .collection("users")
      .doc(userId)
      .collection("message")
      .doc(snapshot.id)
      .update({
        messageId: snapshot.id,
      });
  });
