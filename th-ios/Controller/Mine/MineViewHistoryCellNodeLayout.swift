//
//  MineViewHistoryCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/24.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

fileprivate let kContentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)

class MineViewHistoryCellNode: ASCellNode, MineViewHistoryCellNodeLayout {
    
    lazy var sourceInfoBox: SourceInfoBox = {
        return self.makeSourceInfoBox()
    }()
    
    lazy var shareIconImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var shareTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var deleteButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    override init() {
        super.init()
        
        self.sourceInfoBox.backgroundColor = UIColor.white
        self.shareIconImageNode.image = UIImage.init(named: "mine_share_gray")
        self.shareIconImageNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        self.shareTextNode.attributedText = "分享".attributedString
        self.deleteButtonNode.setAttributedTitle("删除".attributedString, for: .normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let shareDeleteSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                     spacing: 5,
                                                     justifyContent: ASStackLayoutJustifyContent.start,
                                                     alignItems: ASStackLayoutAlignItems.center,
                                                     children: [self.shareIconImageNode,
                                                                self.shareTextNode,
                                                                self.deleteButtonNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.sourceInfoBox, shareDeleteSpec])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: kContentInset, child: mainSpec)
        return mainInsetSpec
    }
}

protocol MineViewHistoryCellNodeLayout: CellNodeElementLayout {
    var sourceInfoBox: SourceInfoBox { get }
    var shareIconImageNode: ASImageNode { get }
    var shareTextNode: ASTextNode { get }
    var deleteButtonNode: ASButtonNode { get }
}
extension MineViewHistoryCellNodeLayout where Self: MineViewHistoryCellNode {
    func makeSourceInfoBox() -> SourceInfoBox {
        return SourceInfoBox().then {
            self.addSubnode($0)
        }
    }
}
