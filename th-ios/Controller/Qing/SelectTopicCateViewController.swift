//
//  SelectTopocCateViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/3/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SelectTopicCateViewController: BaseTableViewController<SelectTopicCateViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "选择分类")
        
        self.setNavigationBarCloseItem(isHidden: false)
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.catelist.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNode: ASTextCellNode = ASTextCellNode()
        cellNode.text = self.viewModel.catelist[indexPath.row]["name"].stringValue
        cellNode.accessoryType = .disclosureIndicator
        return ASCellNode.createBlock(cellNode: cellNode)
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        viewModel.selectAction.apply(indexPath).start()
        self.popViewController(animated: true)
    }

}
