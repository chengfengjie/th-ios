//
//  CellNodeElementLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol CellNodeElementLayout {}
extension CellNodeElementLayout where Self: ASCellNode {
    func makeAndAddTextNode() -> ASTextNode {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }
    func makeAndAddNetworkImageNode() -> ASNetworkImageNode {
        return ASNetworkImageNode().then {
            self.addSubnode($0)
        }
    }
    func makeAndAddImageNode() -> ASImageNode {
        return ASImageNode().then {
            self.addSubnode($0)
        }
    }
    func makeAndAddButtonNode() -> ASButtonNode {
        return ASButtonNode().then {
            self.addSubnode($0)
        }
    }
}
