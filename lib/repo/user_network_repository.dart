import 'package:bobotagram/constants/firestore_keys.dart';
import 'package:bobotagram/models/firestore/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'helper/transformers.dart';

class UserNetworkRepository with Transformers {
  //트랜스포머 안에있는 모든 변수메소드를 가져와서 사용{
  // Future<void> sendData() {
  //   return FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc("123123123")
  //       .set({"email": "testing@gmail.com", "username": "my user name"});
  // }

  // void getData() {
  //   FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc("123123123")
  //       .get()
  //       .then((docSnapshot) => print(docSnapshot.data()));
  // }

  Future<void> attemptCreateUser({String userKey, String email}) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);

    DocumentSnapshot snapshot =
        await userRef.get(); //해당 레퍼런스에서 데이터를 가져와봄. 스냅샷에 데이터가 없으면 해당 데이터를 넣어줌.
    if (!snapshot.exists) {
      return await userRef
          .set(UserModel.getMapForCreateUser(email)); //맵을 받아와서 데이터를 셋 해
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots() // 현재상태의 유저 데이터를 가져오고. 이후 상태가 변할대마다 우리한테 Document Snapshot 타입 데이터를 Stream으로 보내
        .transform(toUser); // Document Snapshot 타입의 해당 데이터를 UserModel로 변환시켜줌
  }

  Stream<List<UserModel>> getAllUsersWithoutMe() {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }

  Future<void> followUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(myUserKey); //내 유저 레퍼런스 가져오기
    final DocumentSnapshot mySnapshot = await myUserRef.get(); // 스냅샷 가져오기
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey); //다른유저 레퍼런스 가져오기
    final DocumentSnapshot otherSnapshot = await otherUserRef.get(); // 스냅샷 가져오기

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });
        int currentFollowers = otherSnapshot[KEY_FOLLOWERS];
        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers + 1});
      }
    });
  }

  Future<void> unfollowUser({String myUserKey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists) {
        await tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });
        int currentFollowers = otherSnapshot[KEY_FOLLOWERS];
        await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers - 1});
      }
    });
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
