//
//  TreeHoleViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TreeHoleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "树洞")
    }
}
