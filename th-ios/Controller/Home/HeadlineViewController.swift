//
//  HeadlineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HeadlineViewController: BaseTableViewController, MagicContentLayoutProtocol, HeadlineViewControllerLayout {
    
    lazy var tableNodeHeader: CarouseTableNodeHeader = {
        return self.makeHeadlineTableNodeHeader()
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
    
    }
    
    func handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType) {
        switch type {
        case .leaderboards:
            self.pushViewController(viewController: LeaderboardsViewController(style: .plain))
        case .author:
            self.pushViewController(viewController: AuthorListViewController())
        case .special:
            self.pushViewController(viewController: SpecialTopicListController(style: .plain))
        case .treehole:
            self.pushViewController(viewController: TreeHoleViewController())
        }
    }
        
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(viewController: ArticleDetailViewController())
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            if indexPath.row == 0 {
                let textNode = ArticleListCellNode.init()
                return textNode
            } else {
                let node = ArticleListImageCellNode.init()
                return node
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableNodeHeaderBounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableNodeHeader.container
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 120),
                                max: CGSize.init(width: self.window_width, height: 500))
    }

}

