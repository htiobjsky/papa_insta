import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/models/firestore/post_model.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/repo/image_network_repository.dart';
import 'package:bobotagram/repo/post_network_repository.dart';
import 'package:bobotagram/screens/comment_screen.dart';
import 'package:bobotagram/widgets/comment.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:bobotagram/widgets/rounded_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel postModel;

  Post({
    Key key,
    @required this.postModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.accents[index % Colors.accents.length],
    //   height: 100,
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postHeader(),
        _postImage(),
        _postActions(context),
        _postLikes(),
        _postCaption(),
        _lastComment(),
        _moreComments(context),
      ],
    );
  }

  Widget _postCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxx_gap),
      child: Comment(
        showImage: false,
        text: postModel.caption,
        username: postModel.username,
        dateTime: postModel.postTime,
      ),
    );
  }

  Widget _lastComment() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxx_gap),
      child: Comment(
        showImage: false,
        text: postModel.lastComment,
        username: postModel.lastCommentor,
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        //"${postModel.numOfLikes == null ? 0 : postModel.numOfLikes.length} likes",
        "2000 likes",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/bookmark.png"),
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/comment.png"),
            color: Colors.black87,
          ),
          onPressed: () {
            _goToComments(context);
          },
        ),
        IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/direct_message.png"),
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        Spacer(),
        Consumer<UserModelState>(
          builder: (BuildContext context, UserModelState userModelState,
              Widget child) {
            return IconButton(
                icon: ImageIcon(
                  // AssetImage(postModel.numOfLikes
                  //         .contains(userModelState.userModel.userKey)
                  //     ? 'assets/images/heart_selected.png'
                  //     : 'assets/images/heart.png'),
                  AssetImage('assets/images/heart_selected.png'),
                  color: Colors.redAccent,
                ),
                color: Colors.black87,
                onPressed: () {
                  postNetworkRepository.toggleLike(
                      postModel.postKey, userModelState.userModel.userKey);
                });
          },
        ),
      ],
    );
  }

  Widget _postHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(common_xxx_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text(postModel.username)),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _postImage() {
    return CachedNetworkImage(
      imageUrl: postModel.postImg,
      placeholder: (BuildContext context, String url) {
        return MyProgressIndicator(
          containerSize: size.width,
          progressSize: 50,
        );
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  Widget _moreComments(BuildContext context) {
    return Visibility(
      visible:
          (postModel.numOfComments != null && postModel.numOfComments >= 2),
      child: GestureDetector(
        onTap: () {
          _goToComments(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: common_gap,
          ),
          child: Text("${postModel.numOfComments - 1} more comments..."),
        ),
      ),
    );
  }

  _goToComments(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return CommentsScreen(postModel.postKey);
    }));
  }
}
