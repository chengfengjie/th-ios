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
    
    var contentTableNode: ASTableNode = ASTableNode()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "作者")
        
        self.menuTableNode.delegate = self
        self.menuTableNode.dataSource = self

    }
    
}

extension AuthorListViewController: ASTableDelegate, ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ASTextCellNode().then {
                $0.text = "育儿"
            }
        }
    }
    
}
