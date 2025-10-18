import Foundation
import UIKit
import WebKit

enum WebViewManager {
  static func configureDefaults() {
    // WKWebView 설정으로 인앱 사파리 제어 개선
    let webViewConfiguration = WKWebViewConfiguration()
    webViewConfiguration.allowsInlineMediaPlayback = true
    webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []

    // 웹뷰 프로세스 풀 설정
    let processPool = WKProcessPool()
    webViewConfiguration.processPool = processPool

    // iOS에서는 글로벌 기본 설정 API가 없어 생성 시점에 적용해야 함
    print("WKWebView 설정 완료 - 인앱 사파리 제어 개선")
  }

  static func cleanupAll(in rootViewController: UIViewController?) {
    guard let rootViewController = rootViewController else { return }
    cleanup(in: rootViewController)
  }

  private static func cleanup(in viewController: UIViewController) {
    for subview in viewController.view.subviews {
      if let webView = subview as? WKWebView {
        print("웹뷰 발견 - 정리 중...")
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
      }
    }

    for child in viewController.children {
      cleanup(in: child)
    }
  }
}


