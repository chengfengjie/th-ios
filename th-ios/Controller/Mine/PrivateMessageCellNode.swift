//
//  PrivateMessageCellNode.swift
//  th-ios
//
//  Created by chengfj on 2018/3/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class PrivateMessageCellNode: ASCellNode, NodeElementMaker {
    
    lazy var avatar: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var messageTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var dateTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var indicator: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    init(dataJSON: JSON, avatar: String) {
        super.init()
        
        self.selectionStyle = .none
        
        self.avatar.url = URL.init(string: avatar)
        self.avatar.defaultImage = UIImage.defaultImage
        self.avatar.style.preferredSize = CGSize.init(width: 40, height: 40)
        self.avatar.cornerRadius = 20
        
        self.messageTextNode.attributedText = dataJSON["message"].stringValue
            .withTextColor(Color.color3)
            .withFont(Font.sys(size: 14))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        self.messageTextNode.cornerRadius = 5
        self.messageTextNode.clipsToBounds = true
        
        self.dateTextNode.attributedText = dataJSON["dateline"].stringValue
            .dateFormat(type: .normal)
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color9)
        
    }
    
    class func create(dataJSON: JSON, toAvatar: String, mineAvatar: String) -> PrivateMessageCellNode {
        if dataJSON["msgfromid"].stringValue == UserModel.current.userID.value {
            return MineMessageCellNode(dataJSON: dataJSON, avatar: mineAvatar)
        } else {
            return ToUserMessageCellNode(dataJSON: dataJSON, avatar: toAvatar)
        }
    }
    
    var messageMaxWidth: CGFloat {
        return UIScreen.main.bounds.width - 95
    }
}

class ToUserMessageCellNode: PrivateMessageCellNode {
    
    override init(dataJSON: JSON, avatar: String) {
        super.init(dataJSON: dataJSON, avatar: avatar)
        
        self.messageTextNode.backgroundColor = UIColor.hexColor(hex: "efefef")
        
        self.messageTextNode.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        self.indicator.image = UIImage.init(named: "private_message_left_indicator")
        
        self.indicator.frame = CGRect.init(x: 63, y: 34, width: 12, height: 12)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 10,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.messageTextNode, self.dateTextNode])
        contentSpec.style.maxWidth = ASDimension.init(unit: ASDimensionUnit.points, value: self.messageMaxWidth)
        let avatarMessageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                       spacing: 15,
                                                       justifyContent: ASStackLayoutJustifyContent.start,
                                                       alignItems: ASStackLayoutAlignItems.start,
                                                       children: [self.avatar, contentSpec])
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20),
                                                   child: avatarMessageSpec)
        return mainInsetSpec
    }
    
}

class MineMessageCellNode: PrivateMessageCellNode {
    override init(dataJSON: JSON, avatar: String) {
        super.init(dataJSON: dataJSON, avatar: avatar)
        
        self.messageTextNode.backgroundColor = UIColor.hexColor(hex: "fae1e7")
        
        self.messageTextNode.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        self.indicator.image = UIImage.init(named: "private_message_right_indicator")
        
        self.indicator.frame = CGRect.init(x: UIScreen.main.bounds.width - 75, y: 34, width: 12, height: 12)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 10,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.end,
                                                 children: [self.messageTextNode, self.dateTextNode])
        contentSpec.style.maxWidth = ASDimension.init(unit: ASDimensionUnit.points, value: self.messageMaxWidth)
        let avatarMessageSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                       spacing: 15,
                                                       justifyContent: ASStackLayoutJustifyContent.end,
                                                       alignItems: ASStackLayoutAlignItems.start,
                                                       children: [contentSpec, self.avatar])
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20),
                                                   child: avatarMessageSpec)
        return mainInsetSpec
    }
}
