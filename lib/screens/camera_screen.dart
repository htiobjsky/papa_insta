import 'package:bobotagram/constants/duration.dart';
import 'package:bobotagram/models/camera_state.dart';
import 'package:bobotagram/models/gallery_state.dart';
import 'package:bobotagram/widgets/my_gallery.dart';
import 'package:bobotagram/widgets/take_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  CameraState _cameraState = CameraState();
  GalleryState _galleryState = GalleryState();
  CameraScreen({Key key}) : super(key: key);

  @override
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();
    _galleryState.initProvider();
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String _title = "Photo";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    widget._cameraState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(
            value: widget._cameraState), // 이렇게 해주면 이 아래 위젯들은 다 이걸 사용 가능함
        ChangeNotifierProvider<GalleryState>.value(
            value: widget._galleryState), // 이렇게 해주면 이 아래 위젯들은 다 이걸 사용 가능함
        // ChangeNotifierProvider(create: (context) => CameraState()),  이렇게도 사용 가능함
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: PageView(
          controller: _pageController,
          children: [
            MyGallery(),
            TakePhoto(),
            Container(
              color: Colors.greenAccent,
            ),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              switch (_currentIndex) {
                case 0:
                  _title = "Gallery";
                  break;
                case 1:
                  _title = "Photo";
                  break;
                case 2:
                  _title = "Video";
                  break;
              }
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: "GALLERY"),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: "PHOTO"),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: "VIDEO"),
          ],
          onTap: _onItemTabbed,
        ),
      ),
    );
  }

  void _onItemTabbed(index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(_currentIndex,
          duration: duration, curve: Curves.fastOutSlowIn);
    });
  }
}
