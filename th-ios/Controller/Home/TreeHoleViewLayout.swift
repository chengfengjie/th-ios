//
//  TreeHoleViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol TreeHoleViewLayout {
}
extension TreeHoleViewLayout {
}

class TreeHoleInfoCellNode: ASCellNode, NodeElementMaker {
    
    lazy var background: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var commentTotalTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var deleteButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    lazy var goodIconImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var goodTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.background.backgroundColor = UIColor.hexColor(hex: "e3f4f8")
        
        self.titleTextNode.attributedText = "安迪 # 广州市"
            .withTextColor(Color.hexColor(hex: "457185"))
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
        
        self.contentTextNode.style.minHeight = ASDimension.init(unit: ASDimensionUnit.points, value: 100)
        
        self.contentTextNode.attributedText = "最新公司需要把前端时间过的项目申请专利，需要我这边把项目代码量统计一下，第一时间找到Xcode插件管理工具Alcatraz，查找插件ZLXCodeLine，这是一个快速统计Xcode工程项目代码量的插件，然而，好像已经不支持Alcatraz安装，在GitHub上也没有找到对应链接，所以有了下面这"
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
        
        self.commentTotalTextNode.attributedText = "评论: 672"
            .withTextColor(Color.color6)
            .withFont(Font.systemFont(ofSize: 12))
        
        self.deleteButtonNode.setAttributedTitle("删除"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.pink), for: UIControlState.normal)
        
        self.goodIconImageNode.image = UIImage.init(named: "qing_like_dark_gray")
        
        self.goodTextNode.attributedText = "123"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color6)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.goodIconImageNode.style.preferredSize = CGSize.init(width: 16, height: 16)
        
        let deleteGoodSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: 10,
                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                    alignItems: ASStackLayoutAlignItems.center,
                                                    children: [self.deleteButtonNode, self.goodIconImageNode, self.goodTextNode])
        
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: 0,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [self.commentTotalTextNode, deleteGoodSpec])
        
        let barInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 25, bottom: 20, right: 25),
                                                  child: barSpec)
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.titleTextNode, self.contentTextNode])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 25, left: 25, bottom: 25, right: 25),
                                                   child: mainSpec)
        
        let mainBacgroundSpec = ASBackgroundLayoutSpec.init(child: mainInsetSpec, background: self.background)

        let mainBarSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 0,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [mainBacgroundSpec, barInsetSpec])
        return mainBarSpec

    }
}

class TreeHoleCommentCellNode: ASCellNode, TreeHoleCommentCellNodeLayout {
    
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var userInfoTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.avatarImageNode.url = URL.init(string: "https://himg.bdimg.com/sys/portrait/item/38b8e69184e5bdb1e5b888e69db0e5a4ab87b1.jpg")
        self.avatarImageNode.cornerRadius = self.avatarSize.width / 2.0
        
        self.userInfoTextNode.attributedText = "沙发  小龙女  01-16 18:08:23"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color9)
        
        self.contentTextNode.attributedText = "时光清浅，新的一天总会如约而至。白云轻轻的飘着，清清的河水静静地流淌着，大地在一片萧瑟中整装待发，孕育着新的生机。人间有爱，岁月沉香。爱，是流淌在心底的清溪，无声的滋润着我们单薄的心。爱是一句温暖的话语，是一份思念，是缤纷绚烂时的热烈。"
            .withTextColor(Color.color3)
            .withFont(Font.systemFont(ofSize: 14))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
    
}

fileprivate protocol TreeHoleCommentCellNodeLayout: NodeElementMaker {
    var avatarImageNode: ASNetworkImageNode { get }
    var userInfoTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
}
extension TreeHoleCommentCellNodeLayout {
    
    var avatarSize: CGSize {
        return CGSize.init(width: 25, height: 25)
    }
    
    var hSpacing: CGFloat {
        return 15
    }
    
    var contentMaxWidth: ASDimension {
        let width: CGFloat = UIScreen.main.bounds.width - self.contentInset.left * 2 - self.hSpacing - self.avatarSize.width
        return ASDimension.init(unit: ASDimensionUnit.points, value: width)
    }
    
    var contentInset: UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    
    func buildLayoutSpec() -> ASLayoutSpec {
        self.avatarImageNode.style.preferredSize = self.avatarSize
        
        self.userInfoTextNode.style.maxWidth = self.contentMaxWidth
        
        self.contentTextNode.style.maxWidth = self.contentMaxWidth
        
        let avatarInfoSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: self.hSpacing,
                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                    alignItems: ASStackLayoutAlignItems.center,
                                                    children: [self.avatarImageNode, self.userInfoTextNode])
        
        let contentSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(
            top: 0, left: self.avatarSize.width + self.hSpacing, bottom: 0, right: 0),
                                                 child: self.contentTextNode)
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 10,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [avatarInfoSpec, contentSpec])
        
        return ASInsetLayoutSpec.init(insets: self.contentInset, child: mainSpec)
    }
    
}



