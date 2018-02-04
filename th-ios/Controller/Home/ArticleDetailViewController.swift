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
    }
    
    func bindViewModel() {
        
        self.viewModel.reactive
            .signal(forKeyPath: "data")
            .observeResult { [weak self] (res) in
                self?.tableNode.reloadData()
        }
        
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ArticleContentCellNode(dataJSON: self.viewModel.dataJSON)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
