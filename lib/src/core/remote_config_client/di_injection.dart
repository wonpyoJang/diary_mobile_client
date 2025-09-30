import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'remote_config_client.dart';

@module
abstract class RemoteConfigModule {
  @lazySingleton
  FirebaseRemoteConfig get firebaseRemoteConfig =>
      FirebaseRemoteConfig.instance;

  @lazySingleton
  RemoteConfigClient remoteConfigClient(FirebaseRemoteConfig rc) =>
      RemoteConfigClient(rc);
}
