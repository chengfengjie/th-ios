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
    
    enum PushAnimateType {
        case cardSlide
        case zoomPush
    }

    var window: UIWindow?

    let animateType: PushAnimateType = .zoomPush
    
    static var rootNavgationController: UINavigationController? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(UIScreen.main.bounds)
        
        // 加载app样式
        AppStyle.loadLocalAppStyle()
        // 设置转场动画
        setupTransitionAnimate()
        // 设置根控制器
        setupRootController()
        return true
    }
    
    /// 设置push 和 present 转场动画
    private func setupTransitionAnimate() {
        switch self.animateType {
        case .cardSlide:
            let animationController = RZCardSlideAnimationController().then {
                $0.horizontalOrientation = false
            }
            RZTransitionsManager.shared().defaultPushPopAnimationController = animationController
            RZTransitionsManager.shared().defaultPresentDismissAnimationController = animationController
        case .zoomPush:
            RZTransitionsManager.shared().defaultPushPopAnimationController = RZZoomPushAnimationController()
            RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomPushAnimationController()
        }
    }
    
    /// 设置rootContrller， 一个UINavigationController，顶层是一个tabbarcontroller
    /// 所有的界面push 和 pop 都通过调用此 rootNavationController的方法处理
    private func setupRootController() {
    
        AppDelegate.rootNavgationController = UINavigationController
            .init(rootViewController: RootViewController())
            .then({
                $0.isNavigationBarHidden = true
                $0.delegate = RZTransitionsManager.shared()
            })
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = AppDelegate.rootNavgationController
        window?.makeKeyAndVisible()
        window?.windowLevel = UIDevice.current.is_iPhoneX ? 0.0 : 1000.0
        window?.backgroundColor = UIColor.white
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

