import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/constants/duration.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/models/firestore/user_model.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/widgets/rounded_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  ProfileBody({Key key, this.onMenuChanged}) : super(key: key);
  final Function onMenuChanged;

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size.width;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    super.dispose();
    _iconAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appbar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(common_gap),
                            child: RoundedAvatar(
                              size: 80,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: common_gap),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    _valueText("123123"),
                                    _valueText("444444"),
                                    _valueText("12313323"),
                                  ]),
                                  TableRow(children: [
                                    _labelText("post"),
                                    _labelText("followers"),
                                    _labelText("following"),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      _username(context),
                      _userBio(),
                      _editProfileBtn(),
                      _tabButtons(),
                      _selectedIndicator(),
                    ],
                  ),
                ),
                _imagesPager(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          color: Colors.transparent,
        ),
        Expanded(
            child: Text(
          "보수와 진보",
          textAlign: TextAlign.center,
        )),
        IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _iconAnimationController,
            ),
            onPressed: () {
              widget.onMenuChanged();
              _iconAnimationController.status == AnimationStatus.completed
                  ? _iconAnimationController.reverse()
                  : _iconAnimationController.forward();
            }),
      ],
    );
  }

  Text _valueText(String value) {
    return Text(
      value,
      style: TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Text _labelText(String value) {
    return Text(
      value,
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
      textAlign: TextAlign.center,
    );
  }

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          AnimatedContainer(
            duration: duration,
            transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
            curve: Curves.fastOutSlowIn,
            child: _images(),
          ),
          AnimatedContainer(
            duration: duration,
            transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
            curve: Curves.fastOutSlowIn,
            child: _images(),
          ),
        ],
      ),
    );
  }

  GridView _images() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(
        30,
        (index) => CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: 'https://picsum.photos/id/$index/100/100',
        ),
      ),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  Row _tabButtons() {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage("assets/images/grid.png"),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black
                  : Colors.black26,
            ),
            onPressed: () {
              _tabSelected(SelectedTab.left);
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage("assets/images/saved.png"),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black26
                  : Colors.black,
            ),
            onPressed: () {
              _tabSelected(SelectedTab.right);
            },
          ),
        )
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxx_gap),
      child: SizedBox(
        height: 24,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
            side: BorderSide(color: Colors.black45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username(BuildContext context) {
    var userModel = Provider.of<UserModelState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        // 'sdsf',
        // Provider.of<UserModelState>(context).userModel.username,
        userModel == null || userModel.userModel == null
            ? "없음"
            : userModel.userModel.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        "this is what i believe",
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}

enum SelectedTab { left, right }
