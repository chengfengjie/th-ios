//
//  MineViewTopicCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class MineViewTopicCellNode: ASCellNode, MineViewTopicCellNodeLayout {
    
    var imageNodeArray: [ASImageNode] = []

    lazy var categoryTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var shareIconNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var shareTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        self.shareIconNode.style.preferredSize = CGSize.init(width: 15, height: 15)
        
        self.categoryTextNode.attributedText = "种草时间".attributedString
        self.titleTextNode.attributedText = "我的把实打实会话体验".attributedString
        self.contentTextNode.attributedText = "我的把实打实会话体验我的把实打实会话体验我的把实打实会话体验我的把实打实会话体验我的把实打实会话体验".attributedString
        self.shareIconNode.image = UIImage.init(named: "mine_share_gray")
        self.shareTextNode.attributedText = "分享".attributedString
        self.imageNodeArray = self.makeImageNodes(imageUrlArray: [
            URL.init(string: "http://d.hiphotos.baidu.com/image/h%3D300/sign=9af99ce45efbb2fb2b2b5e127f4b2043/a044ad345982b2b713b5ad7d3aadcbef76099b65.jpg"),
            URL.init(string: "http://e.hiphotos.baidu.com/image/h%3D300/sign=8d3a9ea62c7f9e2f6f351b082f31e962/500fd9f9d72a6059099ccd5a2334349b023bbae5.jpg"),
            URL.init(string: "http://img1.imgtn.bdimg.com/it/u=1167088769,847502684&fm=200&gp=0.jpg")])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.imageNodeArray.isEmpty {
            return self.noneImageCellNodeLayoutSpec
        } else if self.imageNodeArray.count == 1 {
            return self.oneImageCellNodeLayoutSpec
        } else if self.imageNodeArray.count >= 3 {
            return self.threeImageCellNodLayoutSpec
        }
        return self.noneImageCellNodeLayoutSpec
    }
    
    func makeCellNodeBottomBarSpec() -> ASLayoutSpec {
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                      spacing: 5,
                                      justifyContent: ASStackLayoutJustifyContent.end,
                                      alignItems: ASStackLayoutAlignItems.center,
                                      children: [self.shareIconNode, self.shareTextNode])
    }
}

protocol MineViewTopicCellNodeLayout: NodeElementMaker {
    var categoryTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var shareIconNode: ASImageNode { get }
    var shareTextNode: ASTextNode { get }
    var imageNodeArray: [ASImageNode] { get }
    func makeCellNodeBottomBarSpec() -> ASLayoutSpec
}

extension MineViewTopicCellNodeLayout where Self: ASCellNode {
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
}
extension MineViewTopicCellNodeLayout {
    
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
    
    var noneImageCellNodeLayoutSpec: ASLayoutSpec {
        let contentSpec: ASStackLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                                    spacing: 15,
                                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                                    alignItems: ASStackLayoutAlignItems.stretch,
                                                                    children: [self.categoryTextNode,
                                                                               self.titleTextNode,
                                                                               self.contentTextNode,
                                                                               self.makeCellNodeBottomBarSpec()])
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
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.categoryTextNode, imageContentSpec, self.makeCellNodeBottomBarSpec()])
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
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.categoryTextNode,
                                                         self.titleTextNode,
                                                         self.contentTextNode,
                                                         imageSpec,
                                                         self.makeCellNodeBottomBarSpec()])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
        
        return mainInsetSpec
    }
}
