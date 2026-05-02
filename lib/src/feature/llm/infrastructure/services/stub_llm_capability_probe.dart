// Stub — Track C's DeviceCapabilityDetector should replace this during merge.
// When Track C lands their `DeviceCapabilityDetector` (which performs real
// platform/model probes such as Apple Foundation Models availability and
// device RAM checks for Gemma), delete this stub file so injectable codegen
// only sees a single `@LazySingleton(as: ILlmCapabilityProbe)` binding.

import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../domain/i_llm_capability_probe.dart';

@LazySingleton(as: ILlmCapabilityProbe)
class StubLlmCapabilityProbe implements ILlmCapabilityProbe {
  const StubLlmCapabilityProbe();

  @override
  Future<bool> canRunAppleFoundation() async {
    if (Platform.isIOS) return true;
    return false;
  }

  @override
  Future<bool> canRunGemmaLocal() async => true;
}
