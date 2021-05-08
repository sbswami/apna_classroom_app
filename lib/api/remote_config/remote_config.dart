import 'package:apna_classroom_app/api/remote_config/remote_config_defaults.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

initRemoteConfig() async {
  final RemoteConfig remoteConfigInstance = await RemoteConfig.instance;
  await remoteConfigInstance.setDefaults(remoteConfig);

  try {
    await remoteConfigInstance.fetch(expiration: const Duration(hours: 0));
  } catch (e) {
    print(e);
  }
  await remoteConfigInstance.activateFetched();

  remoteConfig = remoteConfigInstance.getAll();
}
