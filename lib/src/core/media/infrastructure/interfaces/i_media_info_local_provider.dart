import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

abstract class IMeidaInfoLocalProvider {
  Future<Either<LocalFailure, List<XFile>>> selectMedias();
}
