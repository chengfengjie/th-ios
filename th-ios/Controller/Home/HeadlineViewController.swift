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
    
    var shouldBatchFetch: Bool = false
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.tableNode.view.separatorColor = UIColor.lineColor
        
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        if self.viewModel.isRecommendation {
            viewModel.getHomeBannerAction.apply(()).start()
            viewModel.bannerList.signal.observeValues { [weak self] (data) in
                self?.tableNodeHeader.carouse.start(with: self!.viewModel.advUrllist)
                self?.fetchData(context: nil)
            }
        } else {
            self.fetchData(context: nil)
        }

        viewModel.clickArticleCellNodeAction.values.observeValues { [weak self] (model) in
            let controller = ArticleDetailViewController(viewModel: model)
            self?.pushViewController(viewController: controller)
        }
    }
    
    func fetchData(context: ASBatchContext?) {
        context?.beginBatchFetching()
        viewModel.fetchDataAction.apply(()).start()
        viewModel.fetchDataAction.values.observeValues({ (data) in
            var beginIndex = self.viewModel.articleList.value.count
            var indexPaths: [IndexPath] = []
            data.forEach({ (item) in
                indexPaths.append(IndexPath.init(row: beginIndex, section: 1))
                beginIndex = beginIndex + 1
            })
            self.viewModel.articleList.value.append(contentsOf: data)
            if context == nil {
                self.tableNode.reloadData()
                self.shouldBatchFetch = true
            } else {
                self.tableNode.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
            }
            context?.completeBatchFetching(true)
        })
        viewModel.fetchDataAction.errors.observeValues { (error) in
            context?.completeBatchFetching(true)
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
            let controller = SpecialListController(viewModel: viewModel.specialTopiclistViewModel)
            self.pushViewController(viewController: controller)
        case .treehole:
            break
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
        
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : self.viewModel.articleList.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel.clickArticleCellNodeAction.apply(indexPath).start()
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 1 {
            let data: JSON = self.viewModel.articleList.value[indexPath.row]
            
            let imageUrl: String = data["coverImage"].stringValue
            
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
            return self.viewModel.bannerList.value.isEmpty ? 0.1 : self.carouseBounds.height
        } else {
            return self.viewModel.isRecommendation ? self.menuBarHeight : 0.1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return  self.viewModel.bannerList.value.isEmpty ? nil : self.tableNodeHeader.container
        } else {
            return self.viewModel.isRecommendation ? self.menuBarHeader.container : nil
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 120),
                                max: CGSize.init(width: self.window_width, height: 500))
    }
    
    override func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.fetchData(context: context)
    }
    
    override func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return self.shouldBatchFetch
    }

}

