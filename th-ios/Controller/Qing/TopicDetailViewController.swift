//
//  TopicDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/8.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TopicDetailViewController: BaseViewController<TopicDetailViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "话题详情")
        
        self.setNavigationBarCloseItem(isHidden: false)
    }

}
