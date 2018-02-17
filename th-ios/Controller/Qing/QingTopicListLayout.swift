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
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.bottomline.backgroundColor = UIColor.lineColor
        
        self.categoryTextNode.attributedText = "分类"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.pink)
        
        self.titleTextNode.attributedText = dataJSON["subject"].stringValue
            .withFont(Font.systemFont(ofSize: 18))
            .withTextColor(Color.color3)
        
        self.contentTextNode.attributedText = dataJSON["message"].stringValue
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
        
        self.sourceAvatarImageNode.url = URL.init(string: dataJSON["uimg"].stringValue)
        self.sourceAvatarImageNode.style.preferredSize = CGSize.init(width: 20, height: 20)
        self.sourceAvatarImageNode.cornerRadius = 10
        self.sourceAvatarImageNode.defaultImage = UIImage.defaultImage
        self.sourceAvatarImageNode.backgroundColor = UIColor.defaultBGColor
        
        self.sourceNameTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color3)
        
        self.viewTotalIconNode.image = UIImage.init(named: "search_eye")
        self.viewTotalIconNode.style.preferredSize = CGSize.init(width: 18, height: 18)
        
        self.viewTotalTextNode.attributedText = dataJSON["views"].stringValue
            .withTextColor(Color.color6)
            .withFont(Font.systemFont(ofSize: 12))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
}
