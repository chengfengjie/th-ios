//
//  AuthorListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorListViewController: BaseViewController<AuthorListViewModel>, AuthorListViewLayout, ASTableDelegate, ASTableDataSource {
    
    lazy var menuTableNode: ASTableNode = {
        return self.makeMenuTableNode()
    }()
    
    lazy var contentTableNode: ASTableNode = {
        return self.makeContentTableNode()
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.makeNavBarBottomline()
        
        self.setNavigationBarTitle(title: "作者")
        
        self.menuTableNode.delegate = self
        self.menuTableNode.dataSource = self
        
        self.contentTableNode.delegate = self
        self.contentTableNode.dataSource = self
        
        self.makeTableNodeSepline()
        
        self.bindViewModel()
    }
        
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.fetchAuthorCateAction.values.observeResult { [weak self] (data) in
            self?.menuTableNode.reloadData()
        }
        
        viewModel.fetchAuthorlistAction.values.observeResult { [weak self] (data) in
            self?.contentTableNode.reloadData()
        }
        
        viewModel.flowUserAction.errors.observeValues { [weak self] (error) in
            switch error {
            case .forbidden:
                self?.rootPresentLoginController()
            default:
                break
            }
        }
        
        viewModel.clickAuthorAction.values.observeValues { [weak self] (model) in
            let controller = AuthorViewController(viewModel: model)
            self?.pushViewController(viewController: controller)
        }
        
        viewModel.flowUserAction.values.observeValues { [weak self] (_) in
            self?.viewModel.fetchAuthorlistAction.apply("").start()
        }
        
        viewModel.cancelFlowAuthorAction.values.observeValues { [weak self] (_) in
            self?.viewModel.fetchAuthorlistAction.apply("").start()
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return tableNode == self.menuTableNode ?
            self.viewModel.authorCatelist.value.count
            : self.viewModel.authorlist.value.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if tableNode == self.menuTableNode {
            let item: AuthorListViewModel.MenuItem = self.viewModel.authorCatelist.value[indexPath.row]
            let cellNode: ASTextCellNode = ASTextCellNode()
            cellNode.selectionStyle = .none
            cellNode.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: 60)
            cellNode.textNode.attributedText = item.name
                .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: NSTextAlignment.center))
                .withTextColor(item.isSelected ? Color.pink : Color.color6)
                .withFont(Font.systemFont(ofSize: 13))
            return ASCellNode.createBlock(cellNode: cellNode)
        } else {
            let cellNode = AuthorListCellNode(dataJSON: self.viewModel.authorlist.value[indexPath.row])
            cellNode.clickAddAction = self.viewModel.flowUserAction
            cellNode.clickCancelAction = self.viewModel.cancelFlowAuthorAction
            return ASCellNode.createBlock(cellNode: cellNode)

        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if tableNode == self.menuTableNode {
            viewModel.authorCatelist.value.forEach { $0.isSelected = false }
            viewModel.authorCatelist.value[indexPath.row].isSelected = true
            tableNode.reloadData()
            viewModel.currentCateID = self.viewModel.authorCatelist.value[indexPath.row].catId
        } else {
            viewModel.clickAuthorAction.apply(indexPath).start()
        }
    }
    
    
}

