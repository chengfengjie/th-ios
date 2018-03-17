//
//  SpecialTopicViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SpecialViewController: BaseTableViewController<SpecialViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "专题")
        
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.articlelist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.viewModel.articlelist.value.count
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return ASCellNode.createBlock(cellNode: SpecialTopicBannerCellNode(dataJSON: self.viewModel.specialInfo))
        } else {
            let data = viewModel.articlelist.value[indexPath.row]
            let cellNode = SpecialTopicArticleListCellNode(dataJSON: data)
            return ASCellNode.createBlock(cellNode: cellNode)
        }
    }
}
