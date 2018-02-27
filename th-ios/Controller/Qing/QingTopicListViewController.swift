//
//  QingTopicListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingTopicListViewController: BaseTableViewController<QingTopicListViewModel> {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: self.viewModel.type.getTitle())

        self.setNavigationBarCloseItem(isHidden: false)
        
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.topiclist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topiclist.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return QingTopicListCellNode(dataJSON: self.viewModel.topiclist.value[indexPath.row])
        }
    }

}
