//
//  TreeHoleViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TreeHoleViewController: BaseTableViewController, TreeHoleViewLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "树洞")
        
        self.setNavigationBarCloseItem(isHidden: false)
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return indexPath.section == 0 ? {
                return TreeHoleInfoCellNode()
            } : {
                return TreeHoleCommentCellNode()
        }
    }
}
