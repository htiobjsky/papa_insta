import 'dart:io';

import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/models/firestore/post_model.dart';
import 'package:bobotagram/models/firestore/user_model.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/repo/image_network_repository.dart';
import 'package:bobotagram/repo/post_network_repository.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class SharePostScreen extends StatefulWidget {
  SharePostScreen(this.imageFile, {Key key, @required this.postKey})
      : super(key: key);

  final File imageFile;
  final String postKey;

  @override
  _SharePostScreenState createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> _tagItems = [
    'abc',
    'cde',
    'fgd',
    'dsfsdf',
    'sdfasdf',
    'dsfsdf',
    'bjskykim'
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
          actions: [
            TextButton(
                onPressed: sharePostProcedure,
                child: Text(
                  "Share",
                  textScaleFactor: 1.4,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ))
          ],
        ),
        body: ListView(
          children: [
            _captionWithImage(),
            _divider(),
            _sectionButton("Tag People"),
            _divider(),
            _sectionButton("Add Location"),
            _tags(),
            SizedBox(
              height: common_s_gap,
            ),
            _divider(),
            SectionSwitch("Facebook"),
            SectionSwitch("Instagram"),
            SectionSwitch("Tumblr"),
            _divider(),
          ],
        ));
  }

  void sharePostProcedure() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => MyProgressIndicator(),
        isDismissible: false,
        enableDrag: false);
    await imageNetworkRepository.uploadImage(widget.imageFile,
        postKey: widget.postKey);

    UserModel usermodel =
        Provider.of<UserModelState>(context, listen: false).userModel;

    await postNetworkRepository.createNewPost(
        widget.postKey,
        PostModel.getMapForCreatePost(
            userKey: usermodel.userKey,
            username: usermodel.username,
            caption: _textEditingController.text));

    print("Post Key : ${widget.postKey}");

    String postImgLink = await imageNetworkRepository
        .getPostImageUrl("1624637663819_kaIoFvJsNXPnvtWMcL5LD0GDlsF3");
    //왜 안되는걸까???? 그냥 key를 String으로 넣어주면 되고, widget.postKey로 받아오면 에러
    await postNetworkRepository.updatePostImageUrl(
        postImg: postImgLink, postKey: widget.postKey);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Tags _tags() {
    return Tags(
      horizontalScroll: true,
      itemCount: _tagItems.length,
      heightHorizontalScroll: 30,
      itemBuilder: (index) => ItemTags(
        index: index,
        title: _tagItems[index],
        activeColor: Colors.grey[200],
        textActiveColor: Colors.black87,
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
      ),
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 1,
    );
  }

  ListTile _sectionButton(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: Icon(Icons.navigate_next),
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: common_gap,
      ),
    );
  }

  ListTile _captionWithImage() {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(vertical: common_gap, horizontal: common_gap),
      leading: Image.file(
        widget.imageFile,
        width: size.width / 6,
        height: size.width / 6,
        fit: BoxFit.cover,
      ),
      title: TextField(
        controller: _textEditingController,
        autofocus: true,
        decoration: InputDecoration(
            hintText: "Write a Caption", border: InputBorder.none),
      ),
    );
  }
}

class SectionSwitch extends StatefulWidget {
  final String _title;

  const SectionSwitch(
    this._title, {
    Key key,
  }) : super(key: key);

  @override
  _SectionSwitchState createState() => _SectionSwitchState();
}

class _SectionSwitchState extends State<SectionSwitch> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget._title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: CupertinoSwitch(
        value: checked,
        onChanged: (onValue) {
          setState(() {
            checked = onValue;
          });
        },
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: common_gap,
      ),
    );
  }
}
