//
//  ArticleNoteListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/7/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleNoteListViewController: BaseTableViewController<ArticleNoteListViewModel> {

    lazy var rightItem: UIButton = {
        self.makeNavBarRightTextItem(text: "添加笔记")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "笔记")
        
        self.tableNode.view.separatorStyle = .none
        
        self.viewModel.requestDataAction.apply(()).start()
        
        bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.noteList.signal.observeValues { [weak self] (data) in
            self?.tableNode.reloadData()
        }
        
        self.rightItem.reactive.controlEvents(UIControlEvents.touchUpInside).observeValues { [weak self] (sender) in
            self?.presentAddNote()
        }
        
        self.viewModel.editNoteAction.values.observeValues { (model) in
            let controller = AddEditNoteViewController(viewModel: model)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func presentAddNote() {
        let model = AddEditNoteViewModel.init(paraContent: self.viewModel.sectionData, aid: self.viewModel.sectionData["articleId"].stringValue)
        self.present(AddEditNoteViewController(viewModel: model), animated: true, completion: nil)
        
        model.saveNoteAction.completed.observeValues { [weak self] (_) in
            self?.viewModel.requestDataAction.apply(()).start()
        }
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.viewModel.noteList.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            if indexPath.section == 0 {
                let cellNode = ArticleNoteListHeaderCellNode(dataJSON: self.viewModel.sectionData)
                return cellNode
            } else {
                let cellNode = ArticleNoteListNoteCellNode.init(dataJSON: self.viewModel.noteList.value[indexPath.row])
                cellNode.deleteNoteAction = self.viewModel.deleteNoteAction
                cellNode.editNoteAction = self.viewModel.editNoteAction
                return cellNode
            }
        }
    }
    
    override func handleClickCloseItem() {
        self.dismiss(animated: true, completion: nil)
    }

}
