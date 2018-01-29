//
//  TreeHoleListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol TreeHoleListViewLayout {
    var headerChangeControl: HeaderChangeControl { get }
}
extension TreeHoleListViewLayout {
    var headerChangeControlSize: CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 45)
    }
    func makeHeaderChangeControl() -> HeaderChangeControl {
        return HeaderChangeControl().then {
            $0.bottomlineWidth = 50
            $0.titles = ["最热", "最新", "同城", "我的"]
            $0.frame = CGRect.init(origin: CGPoint.zero, size: self.headerChangeControlSize)
        }
    }
}

class TreeHoleListBannerCellNode: ASCellNode, NodeElementMaker {
    
    lazy var bannerImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var bannerSize: CGSize = {
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = width * 0.6
        return CGSize.init(width: width, height: height)
    }()
    
    override init() {
        super.init()
        
        self.bannerImageNode.style.preferredSize = self.bannerSize
        self.bannerImageNode.url = URL.init(string: "http://d.hiphotos.baidu.com/image/h%3D300/sign=9af99ce45efbb2fb2b2b5e127f4b2043/a044ad345982b2b713b5ad7d3aadcbef76099b65.jpg")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                      spacing: 0,
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.stretch,
                                      children: [self.bannerImageNode])
    }
    
}

class TreeHoleListCellNode: ASCellNode, TreeHoleListCellNodeLayout {
    fileprivate lazy var containerBox: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    fileprivate lazy var containerTopBox: ContainerTopBox = {
        return ContainerTopBox().then {
            self.addSubnode($0)
        }
    }()
    fileprivate lazy var containerBottomBox: ContainerBottomBox = {
        return ContainerBottomBox().then {
            self.addSubnode($0)
        }
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.containerBox.backgroundColor = UIColor.white
        self.containerBox.shadowColor = UIColor.black.cgColor
        self.containerBox.shadowRadius = 4
        self.containerBox.shadowOpacity = 0.2
        self.containerBox.shadowOffset = CGSize.init(width: 0, height: 5)
        
        self.containerTopBox.backgroundColor = UIColor.hexColor(hex: "eaf3f5")
        self.containerBottomBox.backgroundColor = UIColor.white
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.makeLayoutSpec()
    }
}

fileprivate protocol TreeHoleListCellNodeLayout: NodeElementMaker {
    var containerBox: ASDisplayNode { get }
    var containerTopBox: ContainerTopBox { get }
    var containerBottomBox: ContainerBottomBox { get }
}
extension TreeHoleListCellNodeLayout where Self: ASCellNode {
    
    var contentInset: UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    
    var boxTopHeight: CGFloat {
        return 180
    }
    
    var boxBottomHeight: CGFloat {
        return 50
    }
    
    var containerBoxSize: CGSize {
        let height: CGFloat = self.boxTopHeight + self.boxBottomHeight
        return CGSize.init(width: UIScreen.main.bounds.width - self.contentInset.left * 2, height: height)
    }
    
    func makeLayoutSpec() -> ASLayoutSpec {
        
        self.containerBottomBox.style.height = ASDimension.init(unit: ASDimensionUnit.points,
                                                                value: self.boxBottomHeight)
        
        self.containerTopBox.style.height = ASDimension.init(unit: ASDimensionUnit.points,
                                                             value: self.boxTopHeight)
        
        self.containerBox.style.height = ASDimension.init(unit: ASDimensionUnit.points,
                                                          value: self.containerBoxSize.height)
        
        let boxBackgroundSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                       spacing: 0,
                                                       justifyContent: ASStackLayoutJustifyContent.start,
                                                       alignItems: ASStackLayoutAlignItems.stretch,
                                                       children: [self.containerTopBox, self.containerBottomBox])
        
        let containerSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                   spacing: 0,
                                                   justifyContent: ASStackLayoutJustifyContent.start,
                                                   alignItems: ASStackLayoutAlignItems.stretch,
                                                   children: [self.containerBox])
        
        let bacSpec = ASBackgroundLayoutSpec.init(child: boxBackgroundSpec, background: containerSpec)
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset,
                                                   child: bacSpec)
        return mainInsetSpec
    }
    
}

fileprivate class ContainerTopBox: ASDisplayNode {
    
    lazy var titleTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    lazy var contentTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    override init() {
        super.init()
        
        self.titleTextNode.attributedText = "安迪 # 广州市"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.hexColor(hex: "457185"))
        
        self.contentTextNode.attributedText = "金蝉子私人离开天竺国后，路上，斗战圣佛到"
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color6)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.titleTextNode, self.contentTextNode])
        return ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(20, 20, 20, 20),
                                      child: mainSpec)
    }
}

fileprivate class ContainerBottomBox: ASDisplayNode, NodeElementMaker {
    lazy var commentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var goodIconImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    lazy var goodTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.commentTextNode.attributedText = "评论: 623"
            .withTextColor(Color.color6)
            .withFont(Font.systemFont(ofSize: 12))
        
        self.goodIconImageNode.image = UIImage.init(named: "qing_like_dark_gray")
        
        self.goodTextNode.attributedText = "8271"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color6)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.goodIconImageNode.style.preferredSize = CGSize.init(width: 16, height: 16)
        let goodSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 5,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.goodIconImageNode, self.goodTextNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.commentTextNode, goodSpec])
        return ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(0, 20, 0, 20),
                                      child: mainSpec)
    }
    
}
