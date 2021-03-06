import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/models/firestore/user_model.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/repo/user_network_repository.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:bobotagram/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Follow/Unfollow"),
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: userNetworkRepository.getAllUsersWithoutMe(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Consumer<UserModelState>(builder: (BuildContext context,
                    UserModelState myUserModelState, Widget child) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        UserModel otherUser = snapshot.data[index];
                        bool amIFollowing = myUserModelState
                            .amIFollowingThisUser(otherUser.userKey);
                        return ListTile(
                          onTap: () {
                            setState(() {
                              amIFollowing
                                  ? userNetworkRepository.unfollowUser(
                                      myUserKey:
                                          myUserModelState.userModel.userKey,
                                      otherUserKey: otherUser.userKey)
                                  : userNetworkRepository.followUser(
                                      myUserKey:
                                          myUserModelState.userModel.userKey,
                                      otherUserKey: otherUser.userKey);
                            });
                          },
                          leading: RoundedAvatar(),
                          title: Text(otherUser.username),
                          subtitle:
                              Text("this is user Bio of ${otherUser.username}"),
                          trailing: Container(
                            height: 30,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: amIFollowing
                                    ? Colors.red[50]
                                    : Colors.blue[50],
                                border: Border.all(
                                    color:
                                        amIFollowing ? Colors.red : Colors.blue,
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(8)),
                            child: FittedBox(
                              child: Text(
                                amIFollowing ? "following" : "not following",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey,
                        );
                      },
                      itemCount: snapshot.data.length);
                }),
              );
            } else {
              return MyProgressIndicator();
            }
          }),
    );
  }
}
