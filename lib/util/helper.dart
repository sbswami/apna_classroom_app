import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';

getDeviceID() async {
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  if (GetPlatform.isAndroid) {
    var build = await deviceInfoPlugin.androidInfo;
    return build.androidId; //UUID for Android
  } else if (GetPlatform.isIOS) {
    var data = await deviceInfoPlugin.iosInfo;
    return data.identifierForVendor; //UUID for iOS
  }
  return DateTime.now().microsecondsSinceEpoch;
}

String getUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.toString();
}

int getMinute(int seconds) {
  return seconds ~/ 60;
}

String getMinuteSt(int seconds) {
  int second = seconds % 60;
  return '${getMinute(seconds)} ${S.MINUTE.tr} $second ${S.SECOND.tr}';
}

Iterable<T> zip<T>(Iterable<T> a, Iterable<T> b) sync* {
  final ita = a.iterator;
  final itb = b.iterator;
  bool hasA, hasB;
  while ((hasA = ita.moveNext()) | (hasB = itb.moveNext())) {
    if (hasA) yield ita.current;
    if (hasB) yield itb.current;
  }
}
