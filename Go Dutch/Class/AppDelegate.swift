//
//  AppDelegate.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/1/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit
import TwitterCore
import Fabric
import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.isStatusBarHidden = true

//        Fabric.with([Twitter.self])
        Twitter.sharedInstance().start(withConsumerKey: Twitter_ConsumerKey, consumerSecret: Twitter_SecKey)
//        Fabric.with([Twitter.sharedInstance()])
        
        SBDMain.initWithApplicationId("3FFD8CC9-3488-4068-AABD-C8F2383910EC")
//        SBDMain.initWithApplicationId("6BDDE5CA-E04F-427B-A704-FC90DA8255B5")

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)

    }
}

