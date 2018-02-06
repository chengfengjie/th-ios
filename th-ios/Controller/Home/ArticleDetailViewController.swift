//
//  ArticleDetailViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleDetailViewController: BaseTableViewController {
    
    let viewModel: ArticleDetailViewModel
    
    init(articleID: String) {
        self.viewModel = ArticleDetailViewModel(articleID: articleID)
        super.init(style: UITableViewStyle.grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "文章详情")
        
        self.view.backgroundColor = UIColor.white
        
        self.bindViewModel()
        
        self.tableNode.view.separatorStyle = .none
    }
    
    func bindViewModel() {
        
        self.viewModel.reactive
            .signal(forKeyPath: "data")
            .observeResult { [weak self] (res) in
                self?.tableNode.reloadData()
        }
        
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.viewModel.dataJSON.isEmpty ? 0 : 2
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.dataJSON.isEmpty ? 0 : 1
        } else {
            return self.viewModel.relatedlist.count
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return {
                return ArticleContentCellNode(dataJSON: self.viewModel.dataJSON)
            }
        } else {
            return {
                return ArticleRelatedCellNode(dataJSON: self.viewModel.relatedlist[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 20 : 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? UIView().then({ (header) in
            header.backgroundColor = UIColor.defaultBGColor
        }) : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
