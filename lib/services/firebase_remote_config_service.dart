import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {

  static final FirebaseRemoteConfigService instance = FirebaseRemoteConfigService._internal();
  factory FirebaseRemoteConfigService()=>instance;
  FirebaseRemoteConfigService._internal();

  String version = "1.0.0";
  bool? emergency;

  void initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 60),
      minimumFetchInterval: const Duration(hours: 0),
    ));
    await remoteConfig.fetchAndActivate();

    version = remoteConfig.getString("poppin_version");
    emergency = remoteConfig.getBool("poppin_update_emergency");
  }

}