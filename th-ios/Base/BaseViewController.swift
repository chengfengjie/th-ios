//
//  BaseViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, CustomNavigationBarProtocol {
    
    let content: UIView = UIView.init()

    lazy var customeNavBar: CustomNavBar = {
        return self.makeCustomNavigationBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.content)
        self.content.frame = self.view.bounds
        
        self.setNavigationBarHidden(isHidden: false)
    }
        
    func setNavigationBarHidden(isHidden: Bool) {
        if isHidden {
            self.customeNavBar.navBarBox.isHidden = true
        } else {
            self.customeNavBar.navBarBox.isHidden = false
        }
    }
    
    func setNavigationBarCloseItem(isHidden: Bool) {
        if isHidden {
            self.customeNavBar.closeItem?.removeFromSuperview()
            self.customeNavBar.closeItem = nil
        } else {
            self.makeNavBarLeftIconItem(iconName: "th_close").do({ (item) in
                self.customeNavBar.closeItem = item
                item.reactive.controlEvents(.touchUpInside)
                    .observe({ [weak self] (signal) in
                        self?.popViewController(animated: true)
                    })
            })
        }
    }

}

/// 获取根控制器协议，UIViewController， UIView 可直接获取
protocol RootNavigationControllerProtocol {}
extension UIResponder: RootNavigationControllerProtocol {}
extension RootNavigationControllerProtocol {
    var rootNavigationController: UINavigationController? {
        return AppDelegate.rootNavgationController;
    }
    func pushViewController(viewController: UIViewController, animated: Bool = true) {
        self.rootNavigationController?.pushViewController(viewController, animated: animated)
    }
    func popViewController(animated: Bool) {
        self.rootNavigationController?.popViewController(animated: animated)
    }
}

