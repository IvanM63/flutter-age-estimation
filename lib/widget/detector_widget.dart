import 'dart:async';

import 'package:age_recog_pkl/models/recognition.dart';
import 'package:age_recog_pkl/models/screen_params.dart';
import 'package:age_recog_pkl/widget/stats_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../service/detector_service.dart';
import 'box_widget.dart';

class DetectorWidget extends StatefulWidget {
  const DetectorWidget({super.key});

  @override
  State<DetectorWidget> createState() => _DetectorWidgetState();
}

class _DetectorWidgetState extends State<DetectorWidget>
    with WidgetsBindingObserver {
  //late di sini untuk menghindari null, jadi variable hanya deklarasi ketika terdapat value di dalamnya
  CameraController? _cameraController;

  get _controller => _cameraController;

  //List of camera available on phone, biasanya [0] itu kamera belakang
  late List<CameraDescription> cameras;

  Detector? _detector;

  StreamSubscription? _subscription;

  //draw bounding box
  List<Recognition>? _rect;

  Map<String, String>? stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStateAsync();
  }

  void _initStateAsync() async {
    //Init Camera
    cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    await _cameraController!.initialize().then((value) async {
      await _controller.startImageStream(onLatestImageAvailable);
      setState(() {});
      ScreenParams.previewSize = _controller.value.previewSize!;
    });
    //spawn new detector
    Detector.start().then((instance) {
      setState(() {
        _detector = instance;
        _subscription = instance.resultsStream.stream.listen((values) {
          print(instance);
          setState(() {
            _rect = values['recognitions'];
            stats = values['stats'];
          });
        });
      });
    });
    //nanti saja duluj
  }

  @override
  Widget build(BuildContext context) {
    //kalo camera init null, return empty container
    if (_cameraController == null || !_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    var aspect = 1 / _controller.value.aspectRatio;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspect,
          child: CameraPreview(_controller),
        ),
        // Stats
        _statsWidget(),
        // Bounding boxes
        AspectRatio(
          aspectRatio: aspect,
          child: _boundingBoxes(),
        ),
      ],
    );
  }

  Widget _statsWidget() => (stats != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white.withAlpha(150),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: stats!.entries
                    .map((e) => StatsWidget(e.key, e.value))
                    .toList(),
              ),
            ),
          ),
        )
      : const SizedBox.shrink();

  Widget _boundingBoxes() {
    if (_rect == null) {
      return const SizedBox.shrink();
    }
    return Stack(
        children: _rect!.map((box) => BoxWidget(result: box)).toList());
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    _detector?.processFrame(cameraImage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _cameraController?.stopImageStream();
        _detector?.stop();
        _subscription?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initStateAsync();
        break;
      default:
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    _cameraController!.dispose();
    _subscription?.cancel();
    _detector?.stop();

    super.dispose();
  }
}
