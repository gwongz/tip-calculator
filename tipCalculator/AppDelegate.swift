//
//  AppDelegate.swift
//  tipCalculator
//
//  Created by Grace Wong on 1/6/16.
//  Copyright © 2016 gwongz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let resetBillAmountInMinutes = 1
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
      
        let defaultPercentage: [String: String] = [
            Constants.defaultPercentageKey: "20",
            Constants.maximumPercentageKey: "30",
            Constants.minimumPercentageKey: "15"
        ]
        let defaultDisplay: [String: Bool] = [Constants.defaultDisplayKey: true]

        defaults.registerDefaults(defaultPercentage)
        defaults.registerDefaults(defaultDisplay)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.defaults.setObject(NSDate(), forKey: Constants.lastActiveKey)

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        if let lastActive = self.defaults.objectForKey(Constants.lastActiveKey) {
            let timeInterval = lastActive.timeIntervalSinceNow
            let cutoffInSeconds = self.resetBillAmountInMinutes * 60
            if (abs(Int(timeInterval)) > cutoffInSeconds) {
                self.defaults.setObject("", forKey: Constants.defaultBillAmountKey)
            }
        }
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

