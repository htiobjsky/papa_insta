import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/widgets/rounded_avatar.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final bool showImage;
  final String username;
  final String text;
  final DateTime dateTime;

  Comment({
    Key key,
    this.showImage = true,
    @required this.username,
    @required this.text,
    this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showImage) RoundedAvatar(size: 24),
        if (showImage)
          SizedBox(
            width: common_xxx_gap,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextSpan(text: "    "),
                  TextSpan(text: text, style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
            if (dateTime != null)
              Text(
                dateTime.toIso8601String(),
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
          ],
        ),
      ],
    );
  }
}
