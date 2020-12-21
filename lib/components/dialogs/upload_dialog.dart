import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String NOTES_CONTROLLER_TAG = 'NOTES_UPLOAD_TAG';

class UploadDialog extends StatefulWidget {
  final String tag;

  UploadDialog({Key key, this.tag}) : super(key: key);

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  UploadController controller;
  @override
  void initState() {
    controller = Get.find(tag: widget.tag);
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
                  () => Text(
                      'Uploading ${controller.uploaded}/${controller.maxUpload}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

showUploadDialog(String tag) {
  return showDialog(
    context: Get.context,
    barrierDismissible: false,
    builder: (BuildContext context) => UploadDialog(
      tag: tag,
    ),
  );
}

class UploadController extends GetxController {
  int maxUpload;
  var uploaded = 0.obs;

  UploadController(int maxUpload, uploaded) {
    this.maxUpload = maxUpload;
  }

  increaseUpload() {
    uploaded++;
  }
}
