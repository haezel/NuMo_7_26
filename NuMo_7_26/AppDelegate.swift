//
//  AppDelegate.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        Util.copyFile("usda.sql3")
        
//        // Return status bar to the screen & set its style.
//        let application = UIApplication.sharedApplication()
//        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
//        application.statusBarStyle = UIStatusBarStyle.LightContent
//        
//        // Setup navigation bar appearance.
//        let navigationBar = UINavigationBar.appearance()
//        navigationBar.barTintColor = UIColor.colorFromCode(0xDBE6EC)
//        navigationBar.tintColor = UIColor.whiteColor()
        
        //grab food items from sqlite and put into allFoods[]
        ModelManager.instance.getAllFoodData()
        
        //get and start app with todays date in 2015-06-02 format
        var date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateInFormat = dateFormatter.stringFromDate(date)
        
        //un comment when my day in place...!!!
        dateChosen = dateInFormat
        
        
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

