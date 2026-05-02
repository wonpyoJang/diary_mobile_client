import Flutter
import UIKit
import WebKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Strong reference to the Apple Foundation Models bridge. The bridge owns
  // its FlutterMethodChannel, which retains its handler weakly, so we must
  // keep it alive here.
  private var _appleLlmBridge: AppleLlmBridge?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Apple Foundation Models bridge (iOS 18.1+) — keep a strong reference so
    // the MethodChannel handler remains alive for the app lifetime.
    if let controller = window?.rootViewController as? FlutterViewController {
      _appleLlmBridge = AppleLlmBridge(messenger: controller.binaryMessenger)
    }

    // WKWebView 설정 - 인앱 사파리 제어 개선
    _configureWebView()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func _configureWebView() {
    // WKWebView 설정으로 인앱 사파리 제어 개선
    let webViewConfiguration = WKWebViewConfiguration()
    webViewConfiguration.allowsInlineMediaPlayback = true
    webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
    
    // 웹뷰 프로세스 풀 설정
    let processPool = WKProcessPool()
    webViewConfiguration.processPool = processPool
    
    // 웹뷰 설정을 전역으로 적용 (iOS에서는 기본 설정 사용)
    // WKWebView.setDefaultConfiguration은 존재하지 않음
    
    print("WKWebView 설정 완료 - 인앱 사파리 제어 개선")
  }
  
  // Custom URL Scheme 처리
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // 딥링크 처리
    let handled = super.application(app, open: url, options: options)
    if handled {
      return handled
    }
    
    // 앱이 포그라운드에 있을 때 딥링크 처리
    if let rootViewController = window?.rootViewController {
      // 딥링크를 Flutter에 전달
      if let methodChannel = rootViewController as? FlutterViewController {
        // 딥링크 정보를 Flutter로 전달하는 로직
        print("딥링크 수신: \(url.absoluteString)")
        
        // OAuth 완료 후 웹뷰 정리 시도
        _cleanupWebViews()
      }
    }
    
    return true
  }
  
  // 앱이 백그라운드에서 딥링크로 열릴 때
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    // Universal Links 처리
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      print("Universal Link 수신: \(url.absoluteString)")
      
      // 딥링크를 Flutter에 전달
      if let rootViewController = window?.rootViewController {
        // 딥링크 정보를 Flutter로 전달하는 로직
        
        // OAuth 완료 후 웹뷰 정리 시도
        _cleanupWebViews()
      }
      
      return true
    }
    
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
  
  // 웹뷰 정리 메서드
  private func _cleanupWebViews() {
    // 모든 웹뷰를 찾아서 정리
    if let rootViewController = window?.rootViewController {
      _cleanupWebViewsInViewController(rootViewController)
    }
  }
  
  private func _cleanupWebViewsInViewController(_ viewController: UIViewController) {
    // 현재 뷰 컨트롤러의 뷰에서 웹뷰 찾기
    for subview in viewController.view.subviews {
      if let webView = subview as? WKWebView {
        print("웹뷰 발견 - 정리 중...")
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
      }
    }
    
    // 자식 뷰 컨트롤러들도 확인
    for child in viewController.children {
      _cleanupWebViewsInViewController(child)
    }
  }
}
