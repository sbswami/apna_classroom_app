import 'package:apna_classroom_app/screens/media/apna_video_player.dart';
import 'package:apna_classroom_app/screens/media/image_viewer.dart';
import 'package:apna_classroom_app/screens/media/pdf_viewer.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:get/get.dart';

showMedia(media) {
  if (media == null) return;
  switch (media[C.TYPE]) {
    case E.IMAGE:
      return Get.to(ImageViewer(url: media[C.URL]));
    case E.PDF:
      return Get.to(PdfViewer(url: media[C.URL]));
    case E.VIDEO:
      return Get.to(ApnaVideoPlayer(
        url: media[C.URL],
        title: media[C.TITLE],
      ));
  }
}
