import 'dart:io';

import 'package:bobotagram/repo/helper/image_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageNetworkRepository {
  Future<TaskSnapshot> uploadImage(File originImage,
      {@required String postKey}) async {
    try {
      final File resized = await compute(getResizedImage, originImage);
      // originImage.length().then((value) =>
      //     print('original image size: $value'));
      // resized.length().then((value) => print('resized image size: $value'));
      // await Future.delayed(Duration(seconds: 3));

      final Reference reference = FirebaseStorage.instanceFor()
          .ref()
          .child(_getImagePathByPostKey(postKey));
      final UploadTask uploadTask = reference.putFile(resized);
      return uploadTask.snapshot;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String _getImagePathByPostKey(String postKey) => 'post/$postKey/post.jpg';

  Future<dynamic> getPostImageUrl(String postKey) {
    return FirebaseStorage.instanceFor()
        .ref()
        .child(_getImagePathByPostKey(postKey))
        .getDownloadURL();
  }
}

ImageNetworkRepository imageNetworkRepository = ImageNetworkRepository();
