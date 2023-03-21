import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
  
    GMSServices.provideAPIKey("AIzaSyCqrXP9rV_wyor-we6CxJitbekU_q1tTYE")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
