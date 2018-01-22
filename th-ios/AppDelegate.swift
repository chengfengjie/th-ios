//
//  AppDelegate.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var rootNavgationController: UINavigationController? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupRootController()
        
        if !UIDevice.current.is_iPhoneX {
            window?.windowLevel = 1000
        }
        
        return true
    }
    
    
    /// 设置rootContrller， 一个UINavigationController，顶层是一个tabbarcontroller
    /// 所有的界面push 和 pop 都通过调用此 rootNavationController的方法处理
    private func setupRootController() {
        
        AppDelegate.rootNavgationController = UINavigationController
            .init(rootViewController: RootViewController())
            .then({
                $0.isNavigationBarHidden = true
            })
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = AppDelegate.rootNavgationController
        window?.makeKeyAndVisible()

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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

