import 'package:age_recog_pkl/view/Camera/camera_home_view.dart';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import '../models/screen_params.dart';

import 'package:age_recog_pkl/view/Home/home_page.dart';
import 'package:age_recog_pkl/view/Camera/kamera_page.dart';
import 'package:age_recog_pkl/view/Data/data_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _activeIndex = 0;

  final List<Widget> currentPage = const [HomePage(), CameraHome(), DataPage()];

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
        key: GlobalKey(),
        body: Center(child: currentPage.elementAt(_activeIndex)),
        bottomNavigationBar: CircleNavBar(
          activeIndex: _activeIndex,
          activeIcons: const [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            Icon(
              Icons.data_thresholding,
              color: Colors.white,
            ),
          ],
          inactiveIcons: const [
            Icon(Icons.home_outlined),
            Icon(Icons.camera_alt_outlined),
            Icon(Icons.data_thresholding_outlined),
          ],
          onTap: (index) {
            setState(() {
              _activeIndex = index;
            });
          },
          color: Color.fromARGB(255, 255, 255, 255),
          height: 60,
          circleWidth: 60,
          circleColor: Color.fromARGB(255, 237, 2, 38),
          shadowColor: Color.fromARGB(100, 0, 0, 0),
          elevation: 10,
        ));
  }
}
