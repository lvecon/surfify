import * as functions from "firebase-functions";
import * as admin from "firebase-admin"


admin.initializeApp();

export const onVideoCreated = functions.firestore
.document("videos/{videoId}")
.onCreate(async (snapshot, context) =>{
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
     await snapshot.ref.update({thumbnailUrl: file.publicUrl(), id:snapshot.id});

     const db = admin.firestore();

     await db.collection('users').doc(video.creatorUid).collection("videos").doc(snapshot.id).set({
        thumbnailUrl: file.publicUrl(),
        videoId: snapshot.id,
        createdAt: video.createdAt,
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

       await db.collection('videos').doc(videoId).collection("comments").doc(snapshot.id).update({
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