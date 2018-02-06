//
//  NoneContentArticleCellNode.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

fileprivate let kContentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)

class NoneContentArticleCellNodeImpl: ASCellNode, NoneContentArticleCellNode {
    lazy var categoryTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var imageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var sourceIconImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var sourceTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var unlikeButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    lazy var bottomline: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    var showCateTextNode: Bool = true
    
    override init() {
        super.init()
        
        self.bottomline.backgroundColor = UIColor.lineColor
        self.bottomline.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: CGFloat.pix1)
        
        self.selectionStyle = .none
        
        self.sourceIconImageNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        
        self.categoryTextNode.setText(text: "小学教育", style: self.layoutCss.cateNameTextStyle)
        self.titleTextNode.setText(text: "赵薇和他背后的隐秘富豪", style: self.layoutCss.titleTextStyle)
        self.imageNode.url = URL.init(string: "http://a.hiphotos.baidu.com/image/h%3D300/sign=c17af2b3bb51f819ee25054aeab54a76/d6ca7bcb0a46f21f46612acbfd246b600d33aed5.jpg")
        self.imageNode.style.preferredSize = self.layoutCss.imageSize
        
        self.sourceIconImageNode.url = URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")
        self.sourceIconImageNode.style.preferredSize = self.layoutCss.sourceIconSize
        
        self.sourceTextNode.setText(text: "21世纪", style: self.layoutCss.sourceNameTextStyle)
        
        self.unlikeButtonNode.setTitleText(text: "不喜欢", style: self.layoutCss.sourceNameTextStyle)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
    }
    
    var layoutCss: NoneContentArticleCellNodeStyle {
        return self.css.home_nocontent_article_cell_node
    }
    
}

protocol NoneContentArticleCellNode: NodeElementMaker {
    var categoryTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var imageNode: ASNetworkImageNode { get }
    var sourceIconImageNode: ASNetworkImageNode { get }
    var sourceTextNode: ASTextNode { get }
    var unlikeButtonNode: ASButtonNode { get }
    var showCateTextNode: Bool { get }
    var bottomline: ASDisplayNode { get }
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
    
        var verticalElements: [ASLayoutElement] = [self.categoryTextNode,
                                                    self.titleTextNode,
                                                    self.bottomBarSpec()]
        if !self.showCateTextNode {
            verticalElements = [self.titleTextNode,
                                self.bottomBarSpec()]
        }
        verticalElements.append(self.bottomline)
        
        let mainSpec = ASStackLayoutSpec.init(direction: .vertical,
                                              spacing: 15,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: verticalElements)
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
        
        var verticalElements: [ASLayoutElement] = [self.categoryTextNode,
                                                   contentSpec,
                                                   self.bottomBarSpec()]
        if !self.showCateTextNode {
            verticalElements = [contentSpec, self.bottomBarSpec()]
        }
        verticalElements.append(self.bottomline)

        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: verticalElements)
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
