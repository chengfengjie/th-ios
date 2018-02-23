//
//  QingTopicListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingTopicListViewController: BaseTableViewController<QingTopicListViewModel> {
    
    private let listType: TopicListType = .news
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: self.listType.getTitle())

        self.setNavigationBarCloseItem(isHidden: false)
        
        self.tableNode.view.separatorStyle = .none
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return QingTopicListCellNode(dataJSON: JSON.init([]))
        }
    }

}
