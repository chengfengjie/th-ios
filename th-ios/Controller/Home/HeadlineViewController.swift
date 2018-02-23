//
//  HeadlineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HeadlineViewController: BaseTableViewController<HomeArticleViewModel>,
MagicContentLayoutProtocol, HeadlineViewControllerLayout {
        
    lazy var tableNodeHeader: CarouseTableNodeHeader = {
        return self.makeHeadlineTableNodeHeader()
    }()
    
    lazy var menuBarHeader: HeadlineTopMenuBarHeader = {
        return self.makeMenuBarHeader()
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.tableNode.view.separatorColor = UIColor.lineColor
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        
        viewModel.adDataProperty.signal.observeValues { [weak self] (data) in
            self?.tableNodeHeader.carouse.start(with: self!.viewModel.advUrllist)
            self?.tableNode.reloadData()
        }
        
        viewModel.articleDataProperty.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
        
        viewModel.clickArticleCellNodeAction.values.observeValues { [weak self] (model) in
            let controller = ArticleDetailViewController(viewModel: model)
            self?.pushViewController(viewController: controller)
        }
        
    }
    
    func handleClickTableNodeHeaderItem(type: HeadelineTableNodeHeaderItemType) {
        switch type {
        case .leaderboards:
            let controller = LeaderboardsViewController(viewModel: viewModel.leaderboardsViewModel)
            self.pushViewController(viewController: controller)
        case .author:
            let controller = AuthorListViewController(viewModel: viewModel.authorListViewModel)
            self.pushViewController(viewController: controller)
        case .special:
            let controller = SpecialTopicListController(viewModel: viewModel.specialTopiclistViewModel)
            self.pushViewController(viewController: controller)
        case .treehole:
            break
//            self.pushViewController(viewController: TreeHoleListViewController(style: .plain))
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
        
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : self.viewModel.articleDataProperty.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel.clickArticleCellNodeAction.apply(indexPath).start()
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 1 {
            let data: JSON = self.viewModel.articleDataProperty.value[indexPath.row]
            
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
            return self.viewModel.adDataProperty.value.isEmpty ? 0.1 : self.carouseBounds.height
        } else {
            return self.menuBarHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return  self.viewModel.adDataProperty.value.isEmpty ? nil : self.tableNodeHeader.container
        } else {
            return self.menuBarHeader.container
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 120),
                                max: CGSize.init(width: self.window_width, height: 500))
    }

}

