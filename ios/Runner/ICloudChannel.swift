import Foundation
import Flutter
import UIKit

class ICloudChannel: NSObject {
  static let channelName = "com.crepas.diary/icloud"

  private let channel: FlutterMethodChannel
  private let containerIdentifier = "iCloud.com.crepas.diary"
  private var pendingResult: FlutterResult?

  init(messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(name: ICloudChannel.channelName, binaryMessenger: messenger)
    super.init()
    self.channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {
      case "uploadToICloud":
        guard let args = call.arguments as? [String: Any],
              let fileName = args["fileName"] as? String,
              let content = args["content"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
          return
        }
        self.uploadToICloud(fileName: fileName, content: content, result: result)

      case "saveToICloud":
        guard let args = call.arguments as? [String: Any],
              let filePath = args["path"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing path", details: nil))
          return
        }
        self.saveToICloud(filePath: filePath, result: result)

      case "downloadFromICloud":
        guard let args = call.arguments as? [String: Any],
              let fileName = args["fileName"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
          return
        }
        self.downloadFromICloud(fileName: fileName, result: result)

      case "listICloudFiles":
        self.listICloudFiles(result: result)

      case "exportToFiles":
        guard let args = call.arguments as? [String: Any],
              let filePath = args["path"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing path", details: nil))
          return
        }
        self.exportToFiles(filePath: filePath, result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  static func register(with messenger: FlutterBinaryMessenger) -> ICloudChannel {
    return ICloudChannel(messenger: messenger)
  }

  private func getICloudContainer() -> URL? {
    return FileManager.default
      .url(forUbiquityContainerIdentifier: containerIdentifier)?
      .appendingPathComponent("Documents", isDirectory: true)
  }

  private func uploadToICloud(fileName: String, content: String, result: FlutterResult) {
    guard let icloudDir = getICloudContainer() else {
      result(FlutterError(code: "NO_ICLOUD", message: "iCloud not available", details: nil))
      return
    }

    let fileURL = icloudDir.appendingPathComponent(fileName)
    do {
      try FileManager.default.createDirectory(at: icloudDir, withIntermediateDirectories: true)
      try content.data(using: .utf8)?.write(to: fileURL)
      result(true)
    } catch {
      result(FlutterError(code: "WRITE_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func downloadFromICloud(fileName: String, result: FlutterResult) {
    guard let icloudDir = getICloudContainer() else {
      result(FlutterError(code: "NO_ICLOUD", message: "iCloud not available", details: nil))
      return
    }

    let fileURL = icloudDir.appendingPathComponent(fileName)
    do {
      let data = try Data(contentsOf: fileURL)
      let content = String(data: data, encoding: .utf8)
      result(content)
    } catch {
      result(FlutterError(code: "READ_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func listICloudFiles(result: FlutterResult) {
    guard let icloudDir = getICloudContainer() else {
      result(FlutterError(code: "NO_ICLOUD", message: "iCloud not available", details: nil))
      return
    }

    do {
      let files = try FileManager.default.contentsOfDirectory(atPath: icloudDir.path)
      result(files)
    } catch {
      result(FlutterError(code: "LIST_ERROR", message: error.localizedDescription, details: nil))
    }
  }


  private func saveToICloud(filePath: String, result: @escaping FlutterResult) {
    guard let iCloudDocuments = FileManager.default
            .url(forUbiquityContainerIdentifier: containerIdentifier)?
            .appendingPathComponent("Documents", isDirectory: true) else {
      result(FlutterError(code: "ICLOUD_NOT_AVAILABLE", message: "iCloud Drive not available", details: nil))
      return
    }

    do {
      // Ensure Documents directory exists
      try FileManager.default.createDirectory(at: iCloudDocuments, withIntermediateDirectories: true)

      let sourceUrl = URL(fileURLWithPath: filePath)
      let destinationUrl = iCloudDocuments.appendingPathComponent(sourceUrl.lastPathComponent)

      if FileManager.default.fileExists(atPath: destinationUrl.path) {
        try FileManager.default.removeItem(at: destinationUrl)
      }

      // Move local file into iCloud as a ubiquitous item so it appears in Files app under the app's folder
      try FileManager.default.setUbiquitous(true, itemAt: sourceUrl, destinationURL: destinationUrl)
      result("true")
    } catch {
      result(FlutterError(code: "COPY_FAILED", message: error.localizedDescription, details: nil))
    }
  }

  private func exportToFiles(filePath: String, result: @escaping FlutterResult) {
    let sourceUrl = URL(fileURLWithPath: filePath)
    DispatchQueue.main.async {
      let picker: UIDocumentPickerViewController
      if #available(iOS 14.0, *) {
        picker = UIDocumentPickerViewController(forExporting: [sourceUrl])
      } else {
        picker = UIDocumentPickerViewController(url: sourceUrl, in: .exportToService)
      }
      picker.modalPresentationStyle = .formSheet
      picker.delegate = self
      self.pendingResult = result
      guard let top = self.topViewController() else {
        result(FlutterError(code: "NO_VIEW", message: "No view controller to present", details: nil))
        self.pendingResult = nil
        return
      }
      top.present(picker, animated: true, completion: nil)
    }
  }

  private func topViewController(base: UIViewController? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
      return topViewController(base: selected)
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
}

extension ICloudChannel: UIDocumentPickerDelegate {
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pendingResult?(false)
    pendingResult = nil
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    pendingResult?(true)
    pendingResult = nil
  }
}


