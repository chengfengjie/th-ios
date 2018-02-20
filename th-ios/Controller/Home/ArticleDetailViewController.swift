//
//  ArticleDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleDetailViewController: BaseTableViewController<ArticleDetailViewModel>, ArticleDetailViewLayout {
    
    var articleContentCellNode: ArticleContentCellNode? = nil
    
    lazy var bottomBar: ReaderBottomBar = {
        return self.makeAndLayoutReaderBottomBar()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "文章详情")
        
        self.view.backgroundColor = UIColor.white
                
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.fetchArticleDataAction.apply(()).start()
        
        Signal.combineLatest(viewModel.articleData.signal,
                             viewModel.adData.signal)
            .observeValues { [weak self] (_, _) in
            self?.tableNode.reloadData()
        }
        
        self.bottomBar.goodItem.reactive
            .controlEvents(.touchUpInside)
            .observeValues { (sender) in
                print(sender)
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.viewModel.articleData.value.isEmpty ? 0 : 3
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.articleData.value.isEmpty ? 0 : 1
        } else if section == 1 {
            return 1
        } else {
            return self.viewModel.relatedlist.count
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return {
                let cellNode = ArticleContentCellNode(dataJSON: self.viewModel.articleData.value)
                self.articleContentCellNode = cellNode
                return cellNode
            }
        } else if indexPath.section == 1 {
            return {
                return AdvertisingCellNode(dataJSON: self.viewModel.adData.value)
            }
        } else {
            return {
                return ArticleRelatedCellNode(dataJSON: self.viewModel.relatedlist[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else if section == 1 {
            return 15
        } else {
            return 15
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return (section == 1 || section == 2) ? UIView().then({ (header) in
            header.backgroundColor = UIColor.defaultBGColor
        }) : nil
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.articleContentCellNode?.didScroll()
    }
}
