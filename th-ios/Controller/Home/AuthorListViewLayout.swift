//
//  AuthorListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol AuthorListViewLayout {
    var menuTableNode: ASTableNode { get }
    var contentTableNode: ASTableNode { get }
}
extension AuthorListViewLayout where Self: AuthorListViewController {
    
    var menuTableNodeSize: CGSize {
        return CGSize.init(width: 90, height: self.window_height)
    }
    
    var menuTableNodeFrame: CGRect {
        return CGRect.init(origin: CGPoint.zero, size: self.menuTableNodeSize)
    }
    
    func makeMenuTableNode() -> ASTableNode {
        return ASTableNode.init(style: .grouped).then {
            self.content.addSubnode($0)
            $0.frame = self.menuTableNodeFrame
        }
    }
    
}
