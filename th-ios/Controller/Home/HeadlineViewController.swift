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
    
    lazy var menuBarHeader: HeadlineTopMenuBarHeader = {
        return self.makeMenuBarHeader()
    }()
    
    let viewModel: HomeArticleViewModel
    
    init(cateInfo: JSON) {
        self.viewModel = HomeArticleViewModel.init(cateInfo: cateInfo)
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)

        self.bind()
        
        self.tableNode.view.separatorColor = UIColor.lineColor
    }

    func bind() {
        
        self.viewModel.reactive.signal(forKeyPath: "articleData").observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
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
            self.pushViewController(viewController: TreeHoleListViewController(style: .plain))
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
        
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : self.viewModel.articleData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let dataJSON: JSON = self.viewModel.articleData[indexPath.row] as! JSON
            self.pushViewController(viewController: ArticleDetailViewController(articleID: dataJSON["aid"].stringValue))
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 1 {
            let data: JSON = self.viewModel.articleData[indexPath.row] as! JSON
            
            let imageUrl: String = data["pic"].stringValue
            
            if imageUrl.isEmpty {
                return {
                    return ArticleListCellNode(dataJSON: data)
                }
            } else {
                return {
                    return ArticleListImageCellNode(dataJSON: data)
                }
            }
        } else {
            return {
                return ASTextCellNode()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.viewModel.adData.isEmpty ? 0.1 : self.carouseBounds.height
        } else {
            return self.menuBarHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return  self.viewModel.adData.isEmpty ? nil : self.tableNodeHeader.container
        } else {
            return self.menuBarHeader.container
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 120),
                                max: CGSize.init(width: self.window_width, height: 500))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

