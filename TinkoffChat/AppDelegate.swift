//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 19/09/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var previousState: UIApplicationState?
    
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let stateInfo = getStateInfo()
        print(stateInfo + "\(#function)")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func getStateInfo() -> String {
        let currentState = UIApplication.shared.applicationState
        let currentStateString = currentState.toString
        let previousStateString = previousState?.toString ?? "not running"
        previousState = currentState
        return "Application moved from \(previousStateString) to \(currentStateString): "
    }
}
