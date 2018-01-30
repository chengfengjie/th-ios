//
//  QingTopicListLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class QingTopicListCellNode: ASCellNode, TopicListCellNodeLayout {
    
    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomline()
    }()
    
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
    
    lazy var sourceAvatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var sourceNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var viewTotalIconNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var viewTotalTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    var imageNodeArray: [ASImageNode] = []
    
    func makeCellNodeBottomBarSpec() -> ASLayoutSpec {
        
        let sourceSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: 8,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.center,
                                                children: [self.sourceAvatarImageNode, self.sourceNameTextNode])
        let viewTotalSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                   spacing: 8,
                                                   justifyContent: ASStackLayoutJustifyContent.start,
                                                   alignItems: ASStackLayoutAlignItems.center,
                                                   children: [self.viewTotalIconNode, self.viewTotalTextNode])
        
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: 0,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [sourceSpec, viewTotalSpec])
        
        return barSpec
    }
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.bottomline.backgroundColor = UIColor.lineColor
        
        self.categoryTextNode.attributedText = "美食"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.pink)
        
        self.titleTextNode.attributedText = "在南京的雪中,走到白头"
            .withFont(Font.systemFont(ofSize: 18))
            .withTextColor(Color.color3)
        
        self.contentTextNode.attributedText = "是漫长的黑夜，爱人熟睡去，胎儿夭折去。翻开那本日记，写下今日下雨，我亦怎能不伤心。他才40天，是我没有挽留，还是他已定好要走？来的却也那么匆匆。伴随血液流淌而去，我明明感觉到了你，还未成人形，还未来得及为你准备好新衣。我牢记你是我的第一个孩子，我还为你取了名。兴许，你原本不属于这里，却为何来我人生踏这一足迹，使我背负着自责和骂名。"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
        
        self.sourceAvatarImageNode.url = URL.init(string: "https://himg.bdimg.com/sys/portrait/item/38b8e69184e5bdb1e5b888e69db0e5a4ab87b1.jpg")
        self.sourceAvatarImageNode.style.preferredSize = CGSize.init(width: 19, height: 19)
        self.sourceAvatarImageNode.cornerRadius = 9
        
        self.sourceNameTextNode.attributedText = "落花生"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color3)
        
        self.viewTotalIconNode.image = UIImage.init(named: "search_eye")
        self.viewTotalIconNode.style.preferredSize = CGSize.init(width: 18, height: 18)
        
        self.viewTotalTextNode.attributedText = "121312"
            .withTextColor(Color.color6)
            .withFont(Font.systemFont(ofSize: 12))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
}
