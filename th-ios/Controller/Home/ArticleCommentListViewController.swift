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
        
        self.tableHeader.label.text = viewModel.commentTotal.value.description + "条评论"
        viewModel.commentTotal.signal.observeValues { [weak self] (flag) in
            self?.tableHeader.label.text = flag.description + "条评论"
        }
        
        viewModel.commentlist.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
        
        viewModel.replayCommentAction.values.observeValues { [weak self] (model) in
            let controller = CommentArticleViewController(viewModel: model)
            self?.present(controller, animated: true, completion: nil)
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
        let cellNode = ArticleCommentListCellNode(dataJSON: self.viewModel.commentlist.value[indexPath.row])
        cellNode.replayAction = viewModel.replayCommentAction
        cellNode.likeAction = viewModel.likeCommentAction
        return ASCellNode.createBlock(cellNode: cellNode)
    }
}
