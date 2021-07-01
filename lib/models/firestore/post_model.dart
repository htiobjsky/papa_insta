import 'package:bobotagram/constants/firestore_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postKey;
  final String userKey;
  final String username;
  final String postImg;
  //final List<dynamic>
  //    numOfLikes; //ku==like한사람들 username을 넣어주고. 그 길이를 재서 표현. 어떤 유저가 라익스를 취소할때 기존에 했는지 안했는지알기위
  final String caption;
  final String lastCommentor;
  final String lastComment;
  final DateTime lastCommentTime;
  final int numOfComments;
  final DateTime postTime;
  final DocumentReference reference;

  PostModel.fromMap(Map<String, dynamic> map, this.postKey,
      {this.reference}) //레퍼런스는 아래 스냅샷에서 직접 추출함, 포스트키는 해당 포스트다큐먼트의 키 우리가 직접 추출.
      : userKey = map[KEY_USERKEY],
        username = map[KEY_USERNAME],
        postImg = map[KEY_POSTIMG],
        //numOfLikes = map[KEY_NUMOFLIKES],
        caption = map[KEY_CAPTION],
        lastCommentor = map[KEY_LASTCOMMENTOR],
        lastComment = map[KEY_LASTCOMMENT],
        lastCommentTime = map[KEY_LASTCOMMENTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_LASTCOMMENTTIME] as Timestamp).toDate(),
        numOfComments = map[KEY_NUMOFLIKES],
        postTime = map[KEY_POSTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_POSTTIME] as Timestamp).toDate();

  PostModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.id,
            reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreatePost(
      {String userKey, String username, String caption}) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_POSTIMG] = ""; //postImg는 지금 없고 어떻게 될거냐면 내가 flow를 설명해줄게.
    //map[KEY_NUMOFLIKES] = [];
    map[KEY_CAPTION] = caption;
    map[KEY_LASTCOMMENTOR] = "";
    map[KEY_LASTCOMMENT] = "";
    map[KEY_LASTCOMMENTTIME] = DateTime.now().toUtc();
    map[KEY_NUMOFLIKES] = 0;
    map[KEY_POSTTIME] = DateTime.now().toUtc();
    return map;
  }
}
