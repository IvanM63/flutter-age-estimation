// import 'dart:math';

// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image/image.dart';

// class ScanController extends GetxController {
//   late CameraController cameraController;
//   late List<CameraDescription> cameras;

//   var isCameraInitialized = false.obs;
//   var cameraCount = 0;

//   var x = 0.0;
//   var y = 0.0;
//   var w = 0.0;
//   var h = 0.0;

//   var label = "";

//   @override
//   void onInit() {
//     super.onInit();
//     initCamera();
//     initTfLite();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     cameraController.dispose();
//   }

//   initCamera() async {
//     if (await Permission.camera.request().isGranted) {
//       cameras = await availableCameras();
//       cameraController =
//           await CameraController(cameras[0], ResolutionPreset.max);
//       await cameraController.initialize().then((value) {
//         cameraController.startImageStream((image) {
//           cameraCount++;
//           if (cameraCount % 10 == 0) {
//             cameraCount = 0;
//             objectDetector(image);
//           }
//           update();
//         });
//       });
//       isCameraInitialized.value = true;
//       update();
//     } else {
//       print("Permission Denied");
//     }
//   }

//   initTfLite() async {
//     await Tflite.loadModel(
//         model: "assets/model.tflite",
//         labels: "assets/label.txt",
//         isAsset: true,
//         numThreads: 1,
//         useGpuDelegate: false);
//   }

//   objectDetector(CameraImage image) async {
//     var detector = await Tflite.runModelOnFrame(
//       bytesList: image.planes.map((e) {
//         return e.bytes;
//       }).toList(),
//       asynch: true,
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       numResults: 1,
//       rotation: 90,
//       threshold: 0.4,
//     );

//     if (detector != null) {
//       if (detector.isEmpty) return;
//       print(detector);
//       // var ourDetectedObject = detector.first!;
//       // if (ourDetectedObject['confidence'] * 100 > 45) {
//       //   label = ourDetectedObject['detectedClass'].toString();
//       //   h = ourDetectedObject['rect']['h'];
//       //   w = ourDetectedObject['rect']['w'];
//       //   x = ourDetectedObject['rect']['x'];
//       //   y = ourDetectedObject['rect']['y'];
//       // }
//       update();
//     }
//   }
// }
