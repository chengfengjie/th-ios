//
//  AuthorViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorViewController: BaseTableViewController, AuthorViewLayout {
    
    lazy var changeHeader: AuthorChnageHeader = {
        return self.makeChangeHeader()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "作者")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
    }

    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 19
        default:
            return 0
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return {
                    return AuthorTopBasicInfo()
                }
            } else if indexPath.row == 1 {
                return {
                    return AttentionAuthorCellNode()
                }
            }
        }
        return {
            return AuthorArticleListCellNode()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return self.changeHeader.headerBounds.height
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.changeHeader
        }
        return nil
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            self.pushViewController(viewController: UserListController(style: .grouped))
        }
    }
}
