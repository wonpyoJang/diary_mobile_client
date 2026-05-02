import Flutter
import UIKit
import WebKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Strong reference to the Apple Foundation Models bridge. The bridge owns
  // its FlutterMethodChannel, which retains its handler weakly, so we must
  // keep it alive here.
  private var _appleLlmBridge: AppleLlmBridge?
  private var icloudChannel: ICloudChannel?

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

    // WKWebView 기본 설정 위임
    WebViewManager.configureDefaults()
    
    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    if let controller = window?.rootViewController as? FlutterViewController {
      icloudChannel = ICloudChannel.register(with: controller.binaryMessenger)
    }
    
    return didFinish
  }
  
  // Custom URL Scheme 처리
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // 딥링크 처리
    let handled = super.application(app, open: url, options: options)
    if handled { return handled }

    let didHandle = DeepLinkHandler.handle(url: url, root: window?.rootViewController)
    if didHandle {
      WebViewManager.cleanupAll(in: window?.rootViewController)
      return true
    }

    return false
  }
  
  // 앱이 백그라운드에서 딥링크로 열릴 때
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    let didHandle = DeepLinkHandler.handle(userActivity: userActivity, root: window?.rootViewController)
    if didHandle {
      WebViewManager.cleanupAll(in: window?.rootViewController)
      return true
    }

    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
