//
//  UserListController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class UserListController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "关注的人")
        
        self.setNavigationBarCloseItem(isHidden: false)
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return AttentionUserListCellNode()
        }
    }

}
