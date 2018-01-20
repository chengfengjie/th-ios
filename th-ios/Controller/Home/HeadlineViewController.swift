//
//  HeadlineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HeadlineViewController: BaseTableViewController, MagicContentLayoutProtocol, HeadlineViewControllerLayout {

    let dataSource: [String] = ["排行", "作者", "专题", "树洞", "文章详情", "banner"]
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
    }
    
    lazy var tableNodeHeader: HeadlineViewTableNodeHeader = {
        return self.makeTableNodeHeader()
    }()
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource[indexPath.row] == "排行" {
            self.pushViewController(viewController: LeaderboardsViewController())
        } else if self.dataSource[indexPath.row] == "作者" {
            self.pushViewController(viewController: AuthorListViewController())
        } else if self.dataSource[indexPath.row] == "专题" {
            self.pushViewController(viewController: SpecialTopicViewController())
        } else if self.dataSource[indexPath.row] == "树洞" {
            self.pushViewController(viewController: TreeHoleViewController())
        } else if self.dataSource[indexPath.row] == "文章详情" {
            self.pushViewController(viewController: ArticleDetailViewController())
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let textNode = ASTextCellNode.init()
            textNode.text = self.dataSource[indexPath.row]
            return textNode
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableNodeHeaderBounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableNodeHeader.container
    }

}

