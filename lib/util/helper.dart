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
