//
//  SameCityMainViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityMainViewController: BaseViewController, BaseTabBarItemConfig, MagicControllerContainerProtocol {
    
    lazy var vtMagicController: VTMagicController = {
        return self.createMagicController()
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "同城"
            $0.iconName = "te_building"
            $0.selectedIconName = "te_building"
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.layoutMagicController()
    }
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["推荐", "亲子活动", "新鲜事儿", "教育信息", "周边游", "打折信息"]
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        return self.magicViewDequeueReusableItem(magicView: magicView, itemIndex: itemIndex)
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let identifer: String = "identifer";
        var controller: UIViewController? = magicView.dequeueReusablePage(withIdentifier: identifer)
        if controller == nil {
            controller = SameCityViewController(style: UITableViewStyle.plain)
        }
        return controller!
    }
    
}
