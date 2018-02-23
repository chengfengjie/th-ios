//
//  AuthorViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorViewController: BaseTableViewController<AuthorViewModel>, AuthorViewLayout {
    
    lazy var changeHeader: AuthorChnageHeader = {
        return self.makeChangeHeader()
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "作者")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.tableNode.view.separatorStyle = .none
        
        self.makeNavBarBottomline()
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        changeHeader.clickAction = viewModel.fetchArticlelistAction
        
        viewModel.authorInfo.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadSections(IndexSet.init(integer: 0), with: .automatic)
        }

        viewModel.articlelist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadSections(IndexSet.init(integer: 1), with: .automatic)
        }
    }

    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return self.viewModel.articlelist.value.count
        default:
            return 0
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return {
                    return AuthorTopBasicInfo(dataJSON: self.viewModel.authorInfo.value)
                }
            } else if indexPath.row == 1 {
                return {
                    return AttentionAuthorCellNode()
                }
            }
        }
        return {
            return AuthorArticleListCellNode(dataJSON: self.viewModel.articlelist.value[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return self.changeHeader.headerBounds.height
        }
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.changeHeader
        }
        return nil
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            //self.pushViewController(viewController: UserListController(style: .grouped))
        }
    }
}
