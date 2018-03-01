//
//  PublishTopicViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class PublishTopicViewController: BaseViewController<PublishTopicViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "发布")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
    }

}
