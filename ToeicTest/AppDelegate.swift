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
//mport GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Configure Facebook API
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FIRApp.configure()
        GADMobileAds.configureWithApplicationID("ca-app-pub-8928391130390155~4620208824")
        
        //        // Configure Google
        //        GGLContext.sharedInstance().configureWithError(&configureError)
        //        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        //        GIDSignIn.sharedInstance().delegate = self
        
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
       // if Constants.loginState == LoginState.Facebook {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: [UIApplicationOpenURLOptionsAnnotationKey])
            // } else {
            //            return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
            //
           // }
        }
        
        @available(iOS, introduced=8.0, deprecated=9.0)
        func application(application: UIApplication,openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
           // if Constants.loginState == LoginState.Facebook {
                return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
                // } else {
                //            return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication,annotation: annotation)
               // }
            }
            
            
            func applicationWillResignActive(application: UIApplication) {
                NSLog("WillResign")
                
            }
            
            func applicationDidEnterBackground(application: UIApplication) {
                NSLog("DidEnter")
                
            }
            
            func applicationWillEnterForeground(application: UIApplication) {
                NSLog("nWillEnter")
                
            }
            
            func applicationDidBecomeActive(application: UIApplication) {
                NSLog("DidBecome")
                
            }
            
            func applicationWillTerminate(application: UIApplication) {
                NSLog("WillTerminat")
                
            }
            
            //    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
            //                withError error: NSError!) {
            //        if (error == nil) {
            //
            //        } else {
            //            print("\(error.localizedDescription)")
            //        }
            //    }
            
            //    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
            //                withError error: NSError!) {
            //        // Perform any operations when the user disconnects from app here.
            //        // ...
            //    }
            
}

