//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 19/09/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SwinjectStoryboard.defaultContainer.resolve(IConversationsStorage.self)?.goOffline()
        return true
    }
}
