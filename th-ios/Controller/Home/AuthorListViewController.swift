//
//  AuthorListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorListViewController: BaseViewController, AuthorListViewLayout {
    
    lazy var menuTableNode: ASTableNode = {
        return self.makeMenuTableNode()
    }()
    
    lazy var contentTableNode: ASTableNode = {
        return self.makeContentTableNode()
    }()
    
    let viewModel: AuthorListViewModel = AuthorListViewModel()
    
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
    
    func bindViewModel() {
        self.viewModel.reactive.signal(forKeyPath: "authorCatelist")
            .skipNil().observeValues { [weak self] (val) in
            self?.menuTableNode.reloadData()
        }
        self.viewModel.reactive.signal(forKeyPath: "authorlist")
            .skipNil().observeValues { [weak self] (val) in
            self?.contentTableNode.reloadData()
        }
    }
    
}

extension AuthorListViewController: ASTableDelegate, ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return tableNode == self.menuTableNode ? self.viewModel.authorCatelist.count : self.viewModel.authorJSONlist.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if tableNode == self.menuTableNode {
            return {
                let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle().then {
                    $0.alignment = NSTextAlignment.center
                }
                let item: AuthorListViewModel.MenuItem = self.viewModel.authorCatelist[indexPath.row]
                return ASTextCellNode().then {
                    $0.selectionStyle = .none
                    $0.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: 60)
                    $0.textNode.attributedText = item.name
                        .withParagraphStyle(paraStyle)
                        .withTextColor(item.isSelected ? Color.pink : Color.color6)
                        .withFont(Font.systemFont(ofSize: 13))
                }
            }
        } else {
            return {
                return AuthorListCellNode(dataJSON: self.viewModel.authorJSONlist[indexPath.row])
            }
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if tableNode == self.menuTableNode {
            self.viewModel.authorCatelist.forEach { $0.isSelected = false }
            self.viewModel.authorCatelist[indexPath.row].isSelected = true
            tableNode.reloadData()
            self.viewModel.currentCateID = self.viewModel.authorCatelist[indexPath.row].catId
        } else {
            self.pushViewController(viewController:
                AuthorViewController(authorID: self.viewModel.authorJSONlist[indexPath.row]["id"].stringValue)
            )
        }
    }
    
}
