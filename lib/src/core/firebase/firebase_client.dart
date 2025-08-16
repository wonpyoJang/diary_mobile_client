import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseClient {
  FirebaseClient();

  Future<String?> getFirebaseId() async {
    late String fid;
    try {
      fid = await FirebaseInstallations.instance.getId();
    } on Exception catch (e, stack) {
      debugPrint('Exception 발생: '
          ' [31m$e\n$stack [0m');
      return null;
    } on Error catch (e, stack) {
      debugPrint('Error 발생: '
          ' [31m$e\n$stack [0m');
      return null;
    } catch (e, stack) {
      debugPrint('알 수 없는 예외 발생: '
          ' [31m$e\n$stack [0m');
      return null;
    }
    return fid;
  }
}
