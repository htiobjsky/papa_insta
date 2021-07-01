import 'package:bobotagram/constants/duration.dart';
import 'package:bobotagram/widgets/sign_in_form.dart';
import 'package:bobotagram/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

class FadeStack extends StatefulWidget {
  final int selectedForm;
  const FadeStack({Key key, this.selectedForm}) : super(key: key);

  @override
  _FadeStackState createState() => _FadeStackState();
}

class _FadeStackState extends State<FadeStack>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  List<Widget> forms = [SignUpForm(), SignInForm()];
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: duration);
    _animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FadeStack oldWidget) {
    if (widget.selectedForm != oldWidget.selectedForm) {
      _animationController.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: IndexedStack(
        children: forms,
        index: widget.selectedForm,
      ),
    );
  }
}
