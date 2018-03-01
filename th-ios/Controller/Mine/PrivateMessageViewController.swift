//
//  PrivateMessageViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/31.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class PrivateMessageViewController: BaseViewController<PrivateMessageViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "私信")
        
        self.setNavigationBarCloseItem(isHidden: false)
    }

}
