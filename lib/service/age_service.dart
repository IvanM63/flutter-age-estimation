import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

class AgeEstimationService {
  final inputImageSize = 200;
  final inputImageMean = 127.5;
  final inputImageStd = 127.5;
  final List<String> labels = [
    '0-2',
    '4-6',
    '8-12',
    '15-20',
    '25-32',
    '38-43',
    '48-53',
    '60-100'
  ];
  late Interpreter interpreter;
  late List<List<double>> output;
  late Uint8List _imageData;
  late List<double> _output;
  late List<double> _normalizedImage;
  late List<double> _probabilities;
  late List<double> _age;
  late int _ageIndex;
  late int _ageValue;
  late String _ageRange;
  late String _ageRangeLabel;
  late String _ageRangeLabel2;
  late String _ageRangeLabel3;
  late String _ageRangeLabel4;
  late String _ageRangeLabel5;
  late String _ageRangeLabel6;
  late String _ageRangeLabel7;
  late String _ageRangeLabel8;
  late String _ageRangeLabel9;
  late String _ageRangeLabel10;
  late String _ageRangeLabel11;
  late String _ageRangeLabel12;
  late String _ageRangeLabel13;
  late String _ageRangeLabel14;
  late String _ageRangeLabel15;
  late String _ageRangeLabel16;

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('model_lite_age_q.tflite');
      print('Age model loaded successfully');
    } catch (e) {
      print('Failed to load age model: $e');
    }
  }

  Future<List<double>> predict(Uint8List imageData) async {
    _imageData = imageData;
    _normalizedImage = normalizeImage(_imageData);
    output = List.generate(1, (index) => List.filled(8, 0.0));
    try {
      interpreter.run(_normalizedImage, output);
      _output = output[0];
      _probabilities = softmax(_output);
      _age = _probabilities;
      _ageIndex = _age.indexWhere((element) => element == _age.reduce(max));
      _ageValue = _ageIndex;
      _ageRange = labels[_ageValue];
      _ageRangeLabel = _ageRange;
      _ageRangeLabel2 = _ageRange;
      _ageRangeLabel3 = _ageRange;
      _ageRangeLabel4 = _ageRange;
      _ageRangeLabel5 = _ageRange;
      _ageRangeLabel6 = _ageRange;
      _ageRangeLabel7 = _ageRange;
      _ageRangeLabel8 = _ageRange;
      _ageRangeLabel9 = _ageRange;
      _ageRangeLabel10 = _ageRange;
      _ageRangeLabel11 = _ageRange;
      _ageRangeLabel12 = _ageRange;
      _ageRangeLabel13 = _ageRange;
      _ageRangeLabel14 = _ageRange;
      _ageRangeLabel15 = _ageRange;
      _ageRangeLabel16 = _ageRange;
      print('Age: $_ageRange');
    } catch (e) {
      print('Failed to get age: $e');
    }
    return _age;
  }

  List<double> normalizeImage(Uint8List _imageData) {
    return _imageData
        .map((e) => (e / 255.0 - inputImageMean) / inputImageStd)
        .toList();
  }

  List<double> softmax(List<double> _output) {
    final double sum = _output.map((e) => exp(e)).reduce((a, b) => a + b);
    return _output.map((e) => exp(e) / sum).toList();
  }

  String getAgeRangeLabel() {
    return _ageRangeLabel;
  }

  String getAgeRangeLabel2() {
    return _ageRangeLabel2;
  }

  String getAgeRangeLabel3() {
    return _ageRangeLabel3;
  }

  String getAgeRangeLabel4() {
    return _ageRangeLabel4;
  }

  String getAgeRangeLabel5() {
    return _ageRangeLabel5;
  }

  String getAgeRangeLabel6() {
    return _ageRangeLabel6;
  }

  String getAgeRangeLabel7() {
    return _ageRangeLabel7;
  }

  String getAgeRangeLabel8() {
    return _ageRangeLabel8;
  }

  String getAgeRangeLabel9() {
    return _ageRangeLabel9;
  }

  String getAgeRangeLabel10() {
    return _ageRangeLabel10;
  }

  String getAgeRangeLabel11() {
    return _ageRangeLabel11;
  }

  String getAgeRangeLabel12() {
    return _ageRangeLabel12;
  }

  String getAgeRangeLabel13() {
    return _ageRangeLabel13;
  }

  String getAgeRangeLabel14() {
    return _ageRangeLabel14;
  }

  String getAgeRangeLabel15() {
    return _ageRangeLabel15;
  }

  String getAgeRangeLabel16() {
    return _ageRangeLabel16;
  }

  void dispose() {
    interpreter.close();
  }
}
