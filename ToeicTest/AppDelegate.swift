//
//  AppDelegate.swift
//  ToeicTest
//
//  Created by khactao on 12/30/16.
//
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleMobileAds
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Configure Facebook API
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FIRApp.configure()
        GADMobileAds.configureWithApplicationID("ca-app-pub-8928391130390155~4620208824")
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: homeVC)
        nav.interactivePopGestureRecognizer?.enabled = false
        IQKeyboardManager.sharedManager().enable = true
        self.window?.rootViewController = nav
        return true
    }
    
    
    @available(iOS 9.0, *)
    func application(application: UIApplication,openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: [UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    @available(iOS, introduced=8.0, deprecated=9.0)
    func application(application: UIApplication,openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
}

