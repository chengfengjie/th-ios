//
//  QingTopicListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingTopicListViewController: BaseTableViewController<BaseViewModel> {
    
    enum TopicListType {
        case news
        case published
        case attented
        case viewhistory
        
        func getTitle() -> String {
            switch self {
            case .news:
                return "最新话题"
            case .published:
                return "我发表的话题"
            case .attented:
                return "我参与的话题"
            case .viewhistory:
                return "最近浏览"
            }
        }
    }
    
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
