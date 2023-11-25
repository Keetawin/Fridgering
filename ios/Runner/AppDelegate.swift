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

    GMSServices.provideAPIKey("AIzaSyApy0FvBfEu1Fdc3BoOh6HMQcjp6m2WTzs") // Replace with your API key
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
