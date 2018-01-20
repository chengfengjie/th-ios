//
//  QingViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewController: BaseViewController, BaseTabBarItemConfig {

    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "Qing聊"
            $0.iconName = "te_chat"
            $0.selectedIconName = "te_chat"
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
