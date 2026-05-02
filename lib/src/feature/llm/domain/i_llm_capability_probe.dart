// TODO(merge): Track D creates i_llm_capability_probe.dart with same interface.
// Deduplicate during merge.
abstract class ILlmCapabilityProbe {
  Future<bool> canRunAppleFoundation();
  Future<bool> canRunGemmaLocal();
}
