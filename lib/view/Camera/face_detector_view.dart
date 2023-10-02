import 'dart:async';

import 'package:age_recog_pkl/models/visitor.model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';

import '../../controller/plasa_controller.dart';
import '../../controller/visitor_controller.dart';
import '../../service/detector_service.dart';
import '../../util/face_detector_painter.dart';
import 'detector_view.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key, required this.index, plasaController})
      : _plasaController = plasaController;

  final int index;
  final PlasaController _plasaController;
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

  List<List<double>> countAgeAccuracy = [
    [0, 0.0],
    [0, 0.0],
    [0, 0.0],
    [0, 0.0]
  ];

  List<Map<String, String>>? recognitionList = [];

  List<String> ageList = ["0-14yo", "15-40yo", "41-60yo", "61-100yo"];
  List<String> genderList = ["Female", "Male"];

  final VisitorController _visitorController = Get.put(VisitorController());
  final Visitor visitorTes = Visitor(
    plasa_id: 0,
    acc: "0.892123",
    date: "Kamis",
    time: "12:00",
    ageRange: "15-40yo",
    gender: "Laki-Laki",
  );

  var finalAge = "0-14yo";
  var finalAgeCount = 0.0;
  var finalAccuracy = 0.0;

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
    //loop recognition list
    for (int i = 0; i < recognitionList!.length; i++) {
      if (recognitionList![i]["Age"] == "0-14yo") {
        countAgeAccuracy[0][0] += 1;
        countAgeAccuracy[0][1] +=
            double.parse(recognitionList![i]["Accuracy"]!);
        if (countAgeAccuracy[0][1] != 0) {
          countAgeAccuracy[0][1] /= 2;
        }
      } else if (recognitionList![i]["Age"] == "15-40yo") {
        countAgeAccuracy[1][0] += 1;
        countAgeAccuracy[1][1] +=
            double.parse(recognitionList![i]["Accuracy"]!);
        if (countAgeAccuracy[1][1] != 0) {
          countAgeAccuracy[1][1] /= 2;
        }
      } else if (recognitionList![i]["Age"] == "40-60yo") {
        countAgeAccuracy[2][0] += 1;
        countAgeAccuracy[2][1] +=
            double.parse(recognitionList![i]["Accuracy"]!);
        if (countAgeAccuracy[2][1] != 0) {
          countAgeAccuracy[2][1] /= 2;
        }
      } else {
        countAgeAccuracy[3][0] += 1;
        countAgeAccuracy[3][1] +=
            double.parse(recognitionList![i]["Accuracy"]!);
        if (countAgeAccuracy[3][1] != 0) {
          countAgeAccuracy[3][1] /= 2;
        }
      }
    }

    for (int i = 0; i < countAgeAccuracy!.length; i++) {
      if (finalAgeCount < countAgeAccuracy[i][0]) {
        finalAge = ageList[i];
        finalAgeCount = countAgeAccuracy[i][0];
        finalAccuracy = countAgeAccuracy[i][1];
      }
    }

    //print(countAgeAccuracy);

    //add to database
    _addTaskToDb();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil Menambahkan Data'),
          content: Text("Accuracy: $finalAccuracy \n"
              "Age: $finalAge \n"
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
                recognitionList!.clear();
                countAgeAccuracy = [
                  [0, 0.0],
                  [0, 0.0],
                  [0, 0.0],
                  [0, 0.0]
                ];
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

  _addTaskToDb() async {
    var value = await _visitorController.addVisitor(
        visitor: Visitor(
      acc: finalAccuracy.toString(),
      ageRange: finalAge,
      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      gender: _ageAndGender!["Gender"],
      plasa_id: widget._plasaController.plasaList[widget.index].id,
    ));

    //Update plasa pengunjung
    var plasa = widget._plasaController.plasaList[widget.index];
    plasa.pengunjung = (int.parse(plasa.pengunjung!) + 1).toString();
    widget._plasaController.updatePlasa(plasa);
    //print("MY ID IS: " + "$value");
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
          recognitionList?.add(_ageAndGender!);
          //print(_ageAndGender!["Accuracy"]);
          //print(_ageAndGender);

          //print("There is ${recognitionList!.length}");
          if (recognitionList!.length > 10) {
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
