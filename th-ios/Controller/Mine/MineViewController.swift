//
//  MineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MineViewController: BaseTableViewController, BaseTabBarItemConfig {
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "我的"
            $0.iconName = "te_user"
            $0.selectedIconName = "te_user"
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.addNavigationBarLeftIconTextItem(iconName: "minge_message", title: "消息")
        
        self.addNavigationBarRightIconTextItem(iconName: "mine_setting", title: "设置")
    
    }
}
