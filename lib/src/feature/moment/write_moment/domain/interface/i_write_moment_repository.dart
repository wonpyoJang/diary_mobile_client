import 'dart:io';

import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

abstract class IWriteMomentRepository {
  Future<Either<WriteMomentFailure, List<File>>> selectMedias();

  Future<Either<WriteMomentFailure, Moment>> analyze(Moment text);
}
