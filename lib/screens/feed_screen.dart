import 'package:bobotagram/models/firestore/post_model.dart';
import 'package:bobotagram/repo/post_network_repository.dart';
import 'package:bobotagram/repo/user_network_repository.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:bobotagram/widgets/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen(
    this.followings, {
    Key key,
  }) : super(key: key);
  final List<dynamic> followings;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>.value(
      initialData: [],
      value: postNetworkRepository.fetchPostsFromAllFollowers(followings),
      child: Consumer<List<PostModel>>(
        builder: (BuildContext context, List<PostModel> posts, Widget child) {
          if (posts == null || posts.isEmpty) {
            return MyProgressIndicator();
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.black87,
                  ),
                ),
                title: Text(
                  "보수와 진보",
                  style: TextStyle(
                      fontFamily: "dokdo",
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          //userNetworkRepository.sendData();
                        },
                        icon: ImageIcon(
                          AssetImage(
                            "assets/images/actionbar_camera.png",
                          ),
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: ImageIcon(
                          AssetImage(
                            "assets/images/direct_message.png",
                          ),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )
                ],
                centerTitle: true,
              ),
              body: ListView.builder(
                itemBuilder: (context, index) =>
                    feedListBuilder(context, posts[index]),
                itemCount: posts.length,
              ),
            );
          }
        },
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, PostModel postModel) {
    return Post(
      postModel: postModel,
    );
  }
}
