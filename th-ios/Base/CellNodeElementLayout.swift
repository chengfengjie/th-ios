//
//  CellNodeElementLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol NodeElementMaker {}
extension NodeElementMaker where Self: ASDisplayNode {
    
    func makeDefaultContentInset() -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
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

protocol NodeBottomlineMaker {
    var bottomline: ASDisplayNode { get }
}
extension NodeBottomlineMaker where Self: ASDisplayNode {
    func makeBottomlineNode() -> ASDisplayNode {
        return ASDisplayNode().then {
            self.addSubnode($0)
            $0.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: CGFloat.pix1)
            $0.backgroundColor = UIColor.lineColor
        }
    }
    
    func makeBottomlineWraperSpec(mainSpec: ASLayoutSpec, lineInset: UIEdgeInsets = UIEdgeInsets.zero) -> ASLayoutSpec {
        let lineInsetSpec = ASInsetLayoutSpec.init(insets: lineInset, child: self.bottomline)
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                      spacing: 0,
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.stretch,
                                      children: [mainSpec, lineInsetSpec])
    }

}
