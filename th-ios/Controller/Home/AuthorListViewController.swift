//
//  AuthorListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorListViewController: BaseViewController, AuthorListViewLayout {
    
    private class MenuItem {
        let name: String
        var isSelected: Bool
        init(name: String, isSelect: Bool) {
            self.name = name
            self.isSelected = isSelect
        }
    }
    
    lazy var menuTableNode: ASTableNode = {
        return self.makeMenuTableNode()
    }()
    
    lazy var contentTableNode: ASTableNode = {
        return self.makeContentTableNode()
    }()
    
    private var menuDataSource: [MenuItem] = [
        MenuItem(name: "育儿", isSelect: true),
        MenuItem(name: "生活", isSelect: false),
        MenuItem(name: "资讯", isSelect: false),
        MenuItem(name: "时尚", isSelect: false),
        MenuItem(name: "摄影", isSelect: false),
        MenuItem(name: "孕产", isSelect: false)
    ]
    
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

    }
    
}

extension AuthorListViewController: ASTableDelegate, ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return menuDataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if tableNode == self.menuTableNode {
            return {
                let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle().then {
                    $0.alignment = NSTextAlignment.center
                }
                let item = self.menuDataSource[indexPath.row]
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
                return AuthorListCellNode()
            }
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if tableNode == self.menuTableNode {
            self.menuDataSource.forEach { $0.isSelected = false }
            self.menuDataSource[indexPath.row].isSelected = true
            tableNode.reloadData()
        } else {
            self.pushViewController(viewController: AuthorViewController(style: .grouped))
        }
    }
    
}
