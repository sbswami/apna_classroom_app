import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDialog extends StatefulWidget {
  UploadDialog({Key key}) : super(key: key);
  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Obx(
                  () {
                    return Text(
                        'Uploaded ${UploadController.to.uploaded}/${UploadController.to.maxUpload}');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

showUploadDialog() {
  return showDialog(
    context: Get.context,
    barrierDismissible: false,
    builder: (BuildContext context) => UploadDialog(),
  );
}

class UploadController extends GetxController {
  var maxUpload = 0.obs;
  var uploaded = 0.obs;

  static UploadController get to => Get.find<UploadController>();

  resetUpload(int maxUpload) {
    this.maxUpload = maxUpload.obs;
    uploaded = 0.obs;
  }

  increaseUpload() {
    uploaded++;
  }
}
