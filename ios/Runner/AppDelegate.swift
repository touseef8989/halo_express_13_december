import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
    GeneratedPluginRegistrant.register(with: self)
    
    // GMSServices.provideAPIKey("AIzaSyALtKha2L_PyX2S0UYnZmpJESOhNc01Aeo")
    
    // GMSServices.provideAPIKey("AIzaSyB8-ypkZ-83OMzbMUGrJWa2v-XBIqQWHdo")
    GMSServices.provideAPIKey("AIzaSyAg3RmeUBhk-VJ6hU5fW7twSwuR7wwTwn4")
    
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
