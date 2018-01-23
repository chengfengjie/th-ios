//
//  RootViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class RootViewController: BaseTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([
                HomeViewController(),
                SameCityMainViewController(),
                QingViewController(style: .grouped),
                MineViewController(style: .grouped)
            ], animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
