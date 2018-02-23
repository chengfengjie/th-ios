//
//  ArticleCommentViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleCommentListViewController: BaseViewController<ArticleCommentListViewModel>,
    ArticleCommentListViewLayout, ASTableDelegate, ASTableDataSource {
    
    lazy var mainView: UIView = {
        return self.createMainView()
    }()
    
    lazy var tableNode: ASTableNode = {
        return self.createLayoutTableNode()
    }()
    
    lazy var tableHeader: ArticleCommentListHeaderElement = {
        return self.createTableHeader()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        self.setNavigationBarHidden(isHidden: true)
        
        self.showMainView()
        
        self.tableNode.delegate = self
        
        self.tableNode.dataSource = self
                
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.commentlist.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commentlist.value.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ArticleCommentListCellNode(dataJSON: self.viewModel.commentlist.value[indexPath.row])
        }
    }
}
