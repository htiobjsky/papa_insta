import 'dart:io';

import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/models/camera_state.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/repo/helper/generate_post_key.dart';
import 'package:bobotagram/screens/share_post_screen.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(
      builder: (BuildContext context, CameraState cameraState, Widget child) {
        return Column(
          children: [
            Container(
              color: Colors.black,
              width: size.width,
              height: size.width,
              child: (cameraState.isReadyToTakePhoto)
                  ? _getPreview(cameraState)
                  : MyProgressIndicator(),
            ),
            Expanded(
              child: SizedBox(
                width: size.width / 5 * 2,
                child: OutlinedButton(
                  onPressed: () {
                    if (cameraState.isReadyToTakePhoto) {
                      _attemptTakePhoto(cameraState, context);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      shape: CircleBorder(),
                      side: BorderSide(color: Colors.black12, width: 20)),
                  child: null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getPreview(CameraState cameraState) {
    return ClipRect(
      // Overflow된 부분을 잘라줌
      child: OverflowBox(
        // child 위젯이 정해진 크기 밖으로 나갈수있게끔 해줌
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
            width: size.width,
            height: size.width * cameraState.controller.value.aspectRatio,
            child: CameraPreview(
              cameraState.controller,
            ),
          ),
        ),
      ),
    );
  }

  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async {
    final String postKey = getNewPostKey(
        Provider.of<UserModelState>(context, listen: false).userModel);
    try {
      //final path = join((await getTemporaryDirectory()).path, '$postKey.png');
      XFile picturetaken = await cameraState.controller.takePicture();
      File imageFile = File(picturetaken.path); //이미지 파일 생성

      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SharePostScreen(
                imageFile,
                postKey: postKey,
              )));
    } catch (e) {}
  }
}
