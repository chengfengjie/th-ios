//
//  HomeCategoryViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HomeCategoryViewController: BaseTableViewController, MagicContentLayoutProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
    }

    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let textNode: ASTextCellNode = ASTextCellNode()
            textNode.text = "首页分类"
            return textNode
        }
    }
    
}
