//
//  AppDelegate.swift
//  MoneyViewer
//
//  Created by Valeriy Kovalevskiy on 3/11/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

//bug where devices are not connected is because of scene delegate in iOS 13+

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}
}

