import 'package:injectable/injectable.dart';

@lazySingleton
class FeatureManager {
  bool get featureA => false;
}
