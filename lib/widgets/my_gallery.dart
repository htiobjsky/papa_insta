import 'dart:io';
import 'dart:typed_data';

import 'package:bobotagram/models/gallery_state.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/repo/helper/generate_post_key.dart';
import 'package:bobotagram/screens/share_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyGallery extends StatefulWidget {
  const MyGallery({Key key}) : super(key: key);

  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryState>(
      builder: (BuildContext context, GalleryState galleryState, Widget child) {
        return GridView.count(
          crossAxisCount: 3,
          children: getImages(context, galleryState),
        );
      },
    );
  }

  List<Widget> getImages(BuildContext context, GalleryState galleryState) {
    return galleryState.images
        .map((localImage) => InkWell(
              //클릭이 되도록 InkWell 위젯 사
              onTap: () async {
                Uint8List bytes = await localImage.getScaledImageBytes(
                    galleryState.localImageProvider,
                    0.3); //Local image를 Byte로 변경
                //final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);
                final String postKey = getNewPostKey(
                    Provider.of<UserModelState>(context, listen: false)
                        .userModel);
                try {
                  final path = join(
                      (await getTemporaryDirectory()).path, '$postKey.png');
                  // XFile picturetaken = await cameraState.controller.takePicture();

                  File imageFile = File(path)
                    ..writeAsBytesSync(bytes); //이미지 파일 생성
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SharePostScreen(
                            imageFile,
                            postKey: postKey,
                          )));
                } catch (e) {}
              },
              child: Image(
                image: DeviceImage(localImage, scale: 0.2),
                fit: BoxFit.cover,
              ),
            ))
        .toList();
  }
}
