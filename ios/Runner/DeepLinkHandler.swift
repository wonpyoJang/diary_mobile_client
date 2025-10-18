import Foundation
import UIKit
import Flutter

enum DeepLinkHandler {
  static func handle(url: URL, root: UIViewController?) -> Bool {
    guard let root = root else { return false }

    if let flutterVC = root as? FlutterViewController {
      // 딥링크 정보를 Flutter로 전달하는 로직을 여기에 추가할 수 있음
      print("딥링크 수신: \(url.absoluteString)")
    }

    return true
  }

  static func handle(userActivity: NSUserActivity, root: UIViewController?) -> Bool {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL else { return false }

    print("Universal Link 수신: \(url.absoluteString)")
    return true
  }
}


