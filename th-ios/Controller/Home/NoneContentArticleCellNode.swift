//
//  NoneContentArticleCellNode.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

fileprivate let kContentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)

protocol NoneContentArticleCellNode: CellNodeElementLayout {
    var categoryTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var imageNode: ASNetworkImageNode { get }
    var sourceIconImageNode: ASNetworkImageNode { get }
    var sourceTextNode: ASTextNode { get }
    var unlikeButtonNode: ASButtonNode { get }
}

extension NoneContentArticleCellNode {

    var contentInset: UIEdgeInsets {
        return kContentInset
    }
    var titleWidth: CGFloat {
        return UIScreen.main.bounds.width
            - 20
            - self.imageNode.style.preferredSize.width
            - self.contentInset.left
            - self.contentInset.right
    }

    func buildNoneImageLayoutSpec(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: .vertical,
                                              spacing: 15,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: [self.categoryTextNode,
                                                         self.titleTextNode,
                                                         self.bottomBarSpec()])
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        return mainInsetSpec
    }
    
    func buildImageLayoutSpec(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.titleTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points,
                                                          value: self.titleWidth)
        
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                 spacing: 20,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.titleTextNode, self.imageNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.categoryTextNode,
                                                         contentSpec,
                                                         self.bottomBarSpec()])
        let mainInset = ASInsetLayoutSpec.init(insets: self.contentInset,
                                               child: mainSpec)
        return mainInset
    }
    
    private func bottomBarSpec() -> ASStackLayoutSpec {
        let sourceSpec = ASStackLayoutSpec.init(direction: .horizontal,
                                                spacing: 5,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [self.sourceIconImageNode, self.sourceTextNode])
        let bottomBarSpec = ASStackLayoutSpec.init(direction: .horizontal,
                                                   spacing: 0,
                                                   justifyContent: .spaceBetween,
                                                   alignItems: .center,
                                                   children: [sourceSpec, self.unlikeButtonNode])
        return bottomBarSpec
    }
}
