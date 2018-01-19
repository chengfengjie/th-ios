//
//  HomeViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, BaseTabBarItemConfig, MagicControllerContainerProtocol{
    
    lazy var vtMagicController: VTMagicController = {
        return self.createMagicController()
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "首页"
            $0.iconName = "te_home"
            $0.selectedIconName = "te_home"
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutMagicController()
        
    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["头条", "社会热点", "孕产新妈", "身心健康", "早教幼教", "没收", "扩大", "草原"]
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        if pageIndex == 0 {
            let identifer: String = "headlineIdentifer_\(pageIndex)"
            var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: identifer)
            if controller == nil {
                controller = HeadlineViewController(style: UITableViewStyle.plain)
            }
            return controller!
        } else {
            let identifer: String = "categoryIdentifer_\(pageIndex)"
            var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: identifer)
            if controller == nil {
                controller = HomeCategoryViewController(style: UITableViewStyle.plain)
            }
            return controller!
        }
    }
}

