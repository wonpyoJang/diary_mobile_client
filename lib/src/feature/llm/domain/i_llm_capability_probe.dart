abstract class ILlmCapabilityProbe {
  Future<bool> canRunAppleFoundation();
  Future<bool> canRunGemmaLocal();
}
