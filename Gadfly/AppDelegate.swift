//
//  AppDelegate.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/5/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: CGFloat(115/255.0), green: CGFloat(93/255.0), blue: CGFloat(136/255.0), alpha: 1)]

        GMSServices.provideAPIKey("AIzaSyC2rmzwInAz2gOIN__iOw_ddVH_GKLLFIU")
        GMSPlacesClient.provideAPIKey("AIzaSyC2rmzwInAz2gOIN__iOw_ddVH_GKLLFIU")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        TWTRTwitter.sharedInstance().start(withConsumerKey: "hZmGcfB0YoMuHdO9MBzbcgJoW", consumerSecret: "iLENdsgZZCMeXdR3GPJXsV0OKWBHrQLWynWMGdydoCFYhlhgep")

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = TWTRTwitter.sharedInstance().application(app, open: url, options: options) && FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                            open: url,
                                                                            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
                                                                            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

