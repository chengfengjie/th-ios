//
//  HomeCategoryViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class HomeCategoryViewController: BaseTableViewController<HomeArticleViewModel>, MagicContentLayoutProtocol, CarouselTableHeaderProtocol {
    
    lazy var tableNodeHeader: CarouseTableNodeHeader = {
        return self.makeCarouseHeaderBox()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentTableNodeLayout()
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        
        self.viewModel.bannerList.signal.observeValues { (_) in
            self.tableNodeHeader.carouse.start(with: self.viewModel.advUrllist)
        }
        
        self.viewModel.articleList.signal.observeValues { (data) in
            self.tableNode.reloadData()
        }
        
        viewModel.clickArticleCellNodeAction.values.observeValues { [weak self] (model) in
            let controller = ArticleDetailViewController(viewModel: model)
            self?.pushViewController(viewController: controller)
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.articleList.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let data: JSON = self.viewModel.articleList.value[indexPath.row]
        
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
    }
    
    override func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange.init(min: CGSize.init(width: self.window_width, height: 80),
                                max: CGSize.init(width: self.window_width, height: 900))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.bannerList.value.isEmpty ? 0.1 : self.carouseBounds.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewModel.bannerList.value.isEmpty ? nil : self.tableNodeHeader.container
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        viewModel.clickArticleCellNodeAction.apply(indexPath).start()
    }
    
    override func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        print("willBeginBatchFetchWith")
        context.beginBatchFetching()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            context.completeBatchFetching(true)
        }
    }

    override func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
}

