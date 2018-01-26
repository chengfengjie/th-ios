//
//  ArticleDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "文章详情")
        
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
