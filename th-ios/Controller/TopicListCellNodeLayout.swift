//
//  TopicListCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol TopicListCellNodeLayout: NodeElementMaker {
    var categoryTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var shareIconNode: ASImageNode { get }
    var shareTextNode: ASTextNode { get }
    var imageNodeArray: [ASImageNode] { get }
    var bottomline: ASDisplayNode { get }
    func makeCellNodeBottomBarSpec() -> ASLayoutSpec
}
extension TopicListCellNodeLayout where Self: ASCellNode {
    
    var categoryStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.color = UIColor.color9
        }
    }
    
    var titleTextStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.color = UIColor.color3
            $0.lineSpacing = 3
        }
    }
    
    var contentTextStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.lineSpacing = 4
            $0.color = UIColor.color9
        }
    }
    
    var shareTextStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.color = UIColor.pink
        }
    }
    
    func makeImageNodes(imageUrlArray: [URL?]) -> [ASImageNode] {
        var result: [ASImageNode] = []
        for url in imageUrlArray {
            if (result.count == 3) {
                return result
            }
            result.append(ASImageNode.init(viewBlock: { () -> UIView in
                return UIImageView().then({ (imageView) in
                    imageView.yy_imageURL = url
                })
            }).then({ (node) in
                self.addSubnode(node)
            }))
        }
        return result
    }
    func makeBottomline() -> ASDisplayNode {
        return ASDisplayNode().then {
            self.addSubnode($0)
            $0.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: CGFloat.pix1)
            $0.backgroundColor = UIColor.lineColor
        }
    }
}
extension TopicListCellNodeLayout {
    var contentInset: UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 20)
    }
    
    var rightImageSize: CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    var contentTextNodeMaxWidth: CGFloat {
        return UIScreen.main.bounds.width - self.contentInset.left * 2  - 15.0 - self.rightImageSize.width
    }
    
    var bigImageSize: CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - self.contentInset.left * 2 - 15.0 - self.rightImageSize.width
        let height: CGFloat = self.rightImageSize.height * 2 + 15
        return CGSize.init(width: width, height: height)
    }
    
    func buildLayoutSpec() -> ASLayoutSpec {
        if self.imageNodeArray.isEmpty {
            return self.noneImageCellNodeLayoutSpec
        } else if self.imageNodeArray.count == 1 {
            return self.oneImageCellNodeLayoutSpec
        } else if self.imageNodeArray.count >= 3 {
            return self.threeImageCellNodLayoutSpec
        }
        return self.noneImageCellNodeLayoutSpec
    }
    
    private var cateText: String {
        if let attrText = self.categoryTextNode.attributedText {
            return attrText.string
        }
        return ""
    }
    
    var noneImageCellNodeLayoutSpec: ASLayoutSpec {
        var children: [ASLayoutElement] = [self.titleTextNode,
                                           self.contentTextNode,
                                           self.makeCellNodeBottomBarSpec(),
                                           self.bottomline]
        if !self.cateText.isEmpty {
            children.insert(self.categoryTextNode, at: 0)
        }

        
        let contentSpec: ASStackLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                                    spacing: 15,
                                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                                    alignItems: ASStackLayoutAlignItems.stretch,
                                                                    children: children)
        let contentInsetSpec: ASInsetLayoutSpec = ASInsetLayoutSpec.init(insets: self.contentInset,
                                                                         child: contentSpec)
        return contentInsetSpec
    }
    
    var oneImageCellNodeLayoutSpec: ASLayoutSpec {
        if self.imageNodeArray.isEmpty {
            return self.noneImageCellNodeLayoutSpec
        }
        
        self.imageNodeArray[0].style.preferredSize = self.rightImageSize
        
        self.titleTextNode.style.width = ASDimensionMake(ASDimensionUnit.points, self.contentTextNodeMaxWidth)
        self.contentTextNode.style.width = ASDimensionMake(ASDimensionUnit.points, self.contentTextNodeMaxWidth)
        
        let titleContentSpec: ASStackLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                                         spacing: 15,
                                                                         justifyContent: ASStackLayoutJustifyContent.start,
                                                                         alignItems: ASStackLayoutAlignItems.stretch,
                                                                         children: [self.titleTextNode, self.contentTextNode])
        let image: ASImageNode = self.imageNodeArray.first!
        let imageContentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                      spacing: 15,
                                                      justifyContent: ASStackLayoutJustifyContent.start,
                                                      alignItems: ASStackLayoutAlignItems.stretch,
                                                      children: [titleContentSpec, image])
        
        var children: [ASLayoutElement] = [imageContentSpec, self.makeCellNodeBottomBarSpec(), self.bottomline]
        if !self.cateText.isEmpty {
            children.insert(self.categoryTextNode, at: 0)
        }
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: children)
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        return mainInsetSpec
    }
    
    var threeImageCellNodLayoutSpec: ASLayoutSpec {
        if self.imageNodeArray.isEmpty {
            return self.noneImageCellNodeLayoutSpec
        }
        if self.imageNodeArray.count < 3 {
            return self.oneImageCellNodeLayoutSpec
        }
        
        let image1: ASImageNode = self.imageNodeArray[0]
        let image2: ASImageNode = self.imageNodeArray[1]
        let image3: ASImageNode = self.imageNodeArray[2]
        
        image1.style.preferredSize = self.bigImageSize
        image2.style.preferredSize = self.rightImageSize
        image3.style.preferredSize = self.rightImageSize
        
        let rightImageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                    spacing: 15,
                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                    alignItems: ASStackLayoutAlignItems.stretch,
                                                    children: [image2, image3])
        
        let imageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                               spacing: 15.0,
                                               justifyContent: ASStackLayoutJustifyContent.start,
                                               alignItems: ASStackLayoutAlignItems.stretch,
                                               children: [image1, rightImageSpec])
        
        var children: [ASLayoutElement] = [self.titleTextNode,
                                           self.contentTextNode,
                                           imageSpec,
                                           self.makeCellNodeBottomBarSpec(), self.bottomline]
        if !self.cateText.isEmpty {
            children.insert(self.categoryTextNode, at: 0)
        }
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: children)
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        
        return mainInsetSpec
    }
}
