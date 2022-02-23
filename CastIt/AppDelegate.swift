//
//  AppDelegate.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import UIKit
import Firebase
import SpriteKit
import FBSDKCoreKit
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        LeaderboardManager.shared.authenticateLocalPlayer(presentingVC: nil)
        Settings.setAdvertiserTrackingEnabled(true)
        Settings.shared.isAutoLogAppEventsEnabled = true
        Settings.shared.isAdvertiserIDCollectionEnabled = true
        ApplicationDelegate.shared.application(
                            application,
                            didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        let view = self.window?.rootViewController?.view as! SKView
//        view.isPaused = true
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        let view = self.window?.rootViewController?.view as! SKView
//        view.isPaused = false
        requestDataPermission()
    }
    
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func requestDataPermission() {
            if #available(iOS 14, *) {
                
                
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        Settings.setAdvertiserTrackingEnabled(true)
                        Settings.shared.isAutoLogAppEventsEnabled = true
                        Settings.shared.isAdvertiserIDCollectionEnabled = true
                        Analytics.setUserProperty("true",
                        forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
                                            Analytics.setAnalyticsCollectionEnabled(true)
                        print("Authorized")
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        
                        Settings.setAdvertiserTrackingEnabled(false)
                        Settings.shared.isAutoLogAppEventsEnabled = false
                        Settings.shared.isAdvertiserIDCollectionEnabled = false
                        Analytics.setUserProperty("false",
                        forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
                                            Analytics.setAnalyticsCollectionEnabled(false)
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                })
            } else {
                //you got permission to track, iOS 14 is not yet installed
            }
        }
}


