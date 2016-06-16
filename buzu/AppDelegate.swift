//
//  AppDelegate.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLoader
import Fabric
import Crashlytics
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("migrationComplete") == nil {
            AppManager.sharedInstance.migrateFavorites()
            defaults.setObject(true, forKey: "migrationComplete")
        }

        Fabric.with([Crashlytics.self, Twitter.self])
        Twitter.sharedInstance().startWithConsumerKey(kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = UIColor.init(colorLiteralRed: 82/255.0, green: 50/255.0, blue: 84/255.0, alpha: 1.0)
        config.foregroundColor = .blackColor()
        config.foregroundAlpha = 0.0
        SwiftLoader.setConfig(config)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

