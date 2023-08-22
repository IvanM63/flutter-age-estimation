import 'package:age_recog_pkl/widget/detector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/screen_params.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Recognition"),
      ),
      key: GlobalKey(),
      body: const DetectorWidget(),
    );
  }
}
