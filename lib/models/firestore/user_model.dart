import 'package:bobotagram/constants/firestore_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userKey;
  final String profileImg;
  final String email;
  final List<dynamic> myPosts;
  final int followers;
  final List<dynamic> likedPosts;
  final String username;
  final List<dynamic> followings;
  final DocumentReference reference; // 데이터를 접근해서 user모델을 가져올때 해당 다큐먼트의 위치를 저장해줌

  UserModel.fromMap(Map<String, dynamic> map, this.userKey,
      {this.reference}) //생성자
      : profileImg = map[KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        myPosts = map[KEY_MYPOSTS],
        likedPosts = map[KEY_LIKEDPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS];

  // firebase에서 JSON데이터를 받아와서(map data) 각각 item을 채워줌

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
            reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreateUser(String email) {
    // 맵을 생성해주는 메소
    Map<String, dynamic> map = Map(); //맵을 생성한 후에 생성된 맵에 데이터를 하나씩 넣어줌.
    map[KEY_PROFILEIMG] = '';
    map[KEY_USERNAME] = email.split('@')[0];
    map[KEY_EMAIL] = email;
    map[KEY_LIKEDPOSTS] = [];
    map[KEY_FOLLOWERS] = 0;
    map[KEY_FOLLOWINGS] = [];
    map[KEY_MYPOSTS] = [];
    return map;
  }
}
