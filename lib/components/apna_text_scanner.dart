// import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// Future<String> apnaTextScanner() async {
//   showProgress();
//
//   PickedFile pickedFile = await ImagePicker().getImage(
//     source: ImageSource.camera,
//   );
//
//   if (pickedFile == null) {
//     Get.back();
//     return null;
//   }
//
//   FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(
//     pickedFile.path,
//   );
//
//   TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
//
//   VisionText visionText = await textRecognizer.processImage(visionImage);
//
//   Get.back();
//   return visionText.text;
// }
