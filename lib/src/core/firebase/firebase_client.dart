import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseClient {
  FirebaseClient();

  Future<String?> getFirebaseId() async {
    late String fid;
    try {
      fid = await FirebaseInstallations.instance.getId();
    } catch (e) {
      return null;
    }
    return fid;
  }
}
