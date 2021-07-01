import 'dart:async';

import 'package:bobotagram/models/firestore/comment_model.dart';
import 'package:bobotagram/models/firestore/post_model.dart';
import 'package:bobotagram/models/firestore/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Transformers {
  // toUSer 변수를 하나 지정해줌.
  // Dart언어에서는 function을 통해 매개변수를 전달해줄때 메소드(펑션) 자체를 전달해줄수있음
  // fromHandlers는 타입을 보면 Factory : 생성자와 같은 역할을 한다고 보면 된다.
  final toUser = StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
          UserModel>.fromHandlers(
      //타큐먼트 스냅샷 타입을 유저모델 타입으로 변경
      handleData: (snapshot, sink) async {
    // sink : 데이터를 보내주는 입구
    sink.add(UserModel.fromSnapshot(snapshot));
  });

  final toUsersExceptMe = StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
      List<UserModel>>.fromHandlers(handleData: (snapshot, sink) async {
    // sink : 데이터를 보내주는 입구
    List<UserModel> users = [];
    User _user = await FirebaseAuth.instance.currentUser;
    snapshot.docs.forEach((documentSnapshot) {
      if (_user.uid != documentSnapshot.id)
        users.add(UserModel.fromSnapshot(documentSnapshot));
    });
    sink.add(users);
  });

  final toPosts = StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
      List<PostModel>>.fromHandlers(handleData: (snapshot, sink) async {
    // sink : 데이터를 보내주는 입구
    List<PostModel> posts = [];

    snapshot.docs.forEach((documentSnapshot) {
      posts.add(PostModel.fromSnapshot(documentSnapshot));
    });
    sink.add(posts);
  });

  final toComments = StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
      List<CommentModel>>.fromHandlers(handleData: (snapshot, sink) async {
    // sink : 데이터를 보내주는 입구
    List<CommentModel> comments = [];

    snapshot.docs.forEach((documentSnapshot) {
      comments.add(CommentModel.fromSnapshot(documentSnapshot));
    });
    sink.add(comments);
  });

  final combineListOfPosts =
      StreamTransformer<List<List<PostModel>>, List<PostModel>>.fromHandlers(
          handleData: (listOfPosts, sink) async {
    List<PostModel> posts = [];

    for (final postList in listOfPosts) {
      posts.addAll(postList);
    }

    sink.add(posts);
  });

  final latestToTop =
      StreamTransformer<List<PostModel>, List<PostModel>>.fromHandlers(
          handleData: (posts, sink) async {
    posts.sort((a, b) => b.postTime.compareTo(a.postTime));
    sink.add(posts);
  });
}
