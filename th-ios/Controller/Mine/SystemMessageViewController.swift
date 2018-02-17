//
//  SystemMessageViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/31.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SystemMessageViewController: BaseTableViewController<BaseViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "消息详情")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.tableNode.view.separatorStyle = .none
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return SystemMessageInfoCellNode()
        }
    }

}
