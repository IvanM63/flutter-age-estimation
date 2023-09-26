import 'dart:async';

import 'package:age_recog_pkl/service/age_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../service/detector_service.dart';
import '../widget/face_detector_painter.dart';
import 'detector_view.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView>
    with WidgetsBindingObserver {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  //tensor flow lite
  Detector? _detector;
  StreamSubscription? _subscription;
  Map<String, String>? stats;

  //Age output List
  Map<String, String>? _ageAndGender;

  List<Map<String, String>>? calculateRecognition = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStateAsync();
  }

  void _initStateAsync() async {
    //spawn new detector
    Detector.start().then((instance) {
      setState(() {
        _detector = instance;
        _subscription = instance.resultsStream.stream.listen((values) {
          setState(() {
            _ageAndGender = values['ageAndGender'];
            //_rect = values['recognitions'];
            stats = values['stats'];
          });
        });
      });
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil Menambahkan Data'),
          content: Text("Accuracy: ${_ageAndGender!["Accuracy"]!} \n"
              "Age: ${_ageAndGender!["Age"]} \n"
              "Gender: ${_ageAndGender!["Gender"]} \n"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Pindai Lagi'),
              onPressed: () {
                Navigator.of(context).pop();
                _canProcess = true;
                calculateRecognition!.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(
      InputImage inputImage, CameraImage cameraImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      //Kalo face tidak sama null maka ada isinya bg

      if (faces.isNotEmpty) {
        //print(cameraImage.format.group);
        onLatestImageAvailable(cameraImage, faces[0]);

        if (_ageAndGender != null) {
          calculateRecognition?.add(_ageAndGender!);
          //print(_ageAndGender!["Accuracy"]);
          //print(_ageAndGender);

          print("There is ${calculateRecognition!.length}");
          if (calculateRecognition!.length > 10) {
            if (_ageAndGender != null) {
              _dialogBuilder(context);
            }

            _canProcess = false;
          }
        }

        //_canProcess = false;
      }

      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );

      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';

      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void onLatestImageAvailable(CameraImage image, Face faceDetected) async {
    _detector?.processFrame(image, faceDetected);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
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
    WidgetsBinding.instance.removeObserver(this);
    _canProcess = false;
    _faceDetector.close();
    _subscription?.cancel();
    _detector?.stop();
    super.dispose();
  }
}
