import Flutter
import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

/// Bridge that exposes Apple Foundation Models to Flutter via a MethodChannel.
/// API availability follows the active Xcode SDK (see `#available` below).
final class AppleLlmBridge: NSObject {
    static let channelName = "com.cassette.diary/apple_llm"

    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(
            name: AppleLlmBridge.channelName,
            binaryMessenger: messenger
        )
        super.init()
        self.channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            self.handle(call: call, result: result)
        }
    }

    // MARK: - MethodChannel routing

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isAvailable":
            result(self.checkIsAvailable())
        case "generate":
            self.handleGenerate(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - isAvailable

    private func checkIsAvailable() -> Bool {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            switch SystemLanguageModel.default.availability {
            case .available:
                return true
            case .unavailable:
                return false
            @unknown default:
                return false
            }
        } else {
            return false
        }
        #else
        return false
        #endif
    }

    // MARK: - generate

    private func handleGenerate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let prompt = args["prompt"] as? String else {
            result(FlutterError(
                code: "invalid_arguments",
                message: "Missing required `prompt` argument",
                details: nil
            ))
            return
        }

        let systemInstruction = args["systemInstruction"] as? String
        let maxTokens = args["maxTokens"] as? Int
        let temperature = args["temperature"] as? Double

        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            // Inspect availability before attempting generation so we can map
            // the underlying reason to a stable FlutterError code.
            switch SystemLanguageModel.default.availability {
            case .available:
                break
            case .unavailable(let reason):
                result(Self.flutterError(forUnavailableReason: reason))
                return
            @unknown default:
                result(FlutterError(
                    code: "device_not_eligible",
                    message: "Apple Foundation Models is not available on this device",
                    details: nil
                ))
                return
            }

            Task {
                do {
                    let session: LanguageModelSession
                    if let systemInstruction = systemInstruction, !systemInstruction.isEmpty {
                        session = LanguageModelSession(instructions: systemInstruction)
                    } else {
                        session = LanguageModelSession()
                    }

                    let options = Self.makeGenerationOptions(
                        maxTokens: maxTokens,
                        temperature: temperature
                    )

                    let response = try await session.respond(
                        to: prompt,
                        options: options
                    )

                    // `LanguageModelSession.respond(to:)` returns a wrapper whose
                    // `content` is the generated string.
                    let content = response.content
                    DispatchQueue.main.async {
                        result(content)
                    }
                } catch let error as LanguageModelSession.GenerationError {
                    DispatchQueue.main.async {
                        result(FlutterError(
                            code: "generation_failed",
                            message: error.localizedDescription,
                            details: String(describing: error)
                        ))
                    }
                } catch {
                    DispatchQueue.main.async {
                        result(FlutterError(
                            code: "generation_failed",
                            message: error.localizedDescription,
                            details: String(describing: error)
                        ))
                    }
                }
            }
        } else {
            result(FlutterError(
                code: "device_not_eligible",
                message: "A supported iOS version is required for Apple Foundation Models",
                details: nil
            ))
        }
        #else
        result(FlutterError(
            code: "device_not_eligible",
            message: "FoundationModels framework not available in this build",
            details: nil
        ))
        #endif
    }

    // MARK: - Helpers

    #if canImport(FoundationModels)
    @available(iOS 26.0, *)
    private static func makeGenerationOptions(
        maxTokens: Int?,
        temperature: Double?
    ) -> GenerationOptions {
        // GenerationOptions accepts nil for unspecified fields; pass through as-is.
        return GenerationOptions(
            temperature: temperature,
            maximumResponseTokens: maxTokens
        )
    }

    @available(iOS 26.0, *)
    private static func flutterError(
        forUnavailableReason reason: SystemLanguageModel.Availability.UnavailableReason
    ) -> FlutterError {
        switch reason {
        case .deviceNotEligible:
            return FlutterError(
                code: "device_not_eligible",
                message: "This device is not eligible for Apple Intelligence",
                details: nil
            )
        case .appleIntelligenceNotEnabled:
            return FlutterError(
                code: "intelligence_not_enabled",
                message: "Apple Intelligence is not enabled in Settings",
                details: nil
            )
        case .modelNotReady:
            return FlutterError(
                code: "model_not_ready",
                message: "The on-device language model is still preparing",
                details: nil
            )
        @unknown default:
            return FlutterError(
                code: "device_not_eligible",
                message: "Apple Foundation Models is unavailable",
                details: nil
            )
        }
    }
    #endif
}
