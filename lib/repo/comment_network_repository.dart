import 'package:bobotagram/constants/firestore_keys.dart';
import 'package:bobotagram/models/firestore/comment_model.dart';
import 'package:bobotagram/repo/helper/transformers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentNetworkRepository with Transformers {
  Future<void> createNewComment(
      String postKey, Map<String, dynamic> commentData) async {
    final DocumentReference postRef =
        FirebaseFirestore.instance.collection(COLLECTION_POST).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference commentRef =
        postRef.collection(COLLECTION_COMMENTS).doc();
    print("commentRef : $commentRef");
    return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (postSnapshot.exists) {
        await tx.set(commentRef, commentData);
        print("commentData : $commentData");
        int numOfComments = postSnapshot[KEY_NUMOFCOMMENTS];
        await tx.update(postRef, {
          KEY_NUMOFCOMMENTS: numOfComments + 1,
          KEY_LASTCOMMENT: commentData[KEY_COMMENT],
          KEY_LASTCOMMENTTIME: commentData[KEY_COMMENTTIME],
          KEY_LASTCOMMENTOR: commentData[KEY_USERNAME],
        });
      }
    });
  }

  Stream<List<CommentModel>> fetchAllComments(String postKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_POST)
        .doc(postKey)
        .collection(COLLECTION_COMMENTS)
        .orderBy(
          KEY_COMMENTTIME,
          descending: true,
        )
        .snapshots()
        .transform(toComments);
  }
}

CommentNetworkRepository commentNetworkRepository = CommentNetworkRepository();
