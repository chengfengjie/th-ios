//
//  UserListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol UserListViewLayout {}

protocol UserListCellNodeLayout: NodeElementMaker {
    var avatarImageNode: ASNetworkImageNode { get }
    var userNameTextNode: ASTextNode { get }
    var buttonNode: ASButtonNode { get }
}
extension UserListCellNodeLayout {
    var contentInset: UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    func makeLayoutSpec() -> ASLayoutSpec {
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 50, height: 50)
        self.buttonNode.style.preferredSize = CGSize.init(width: 90, height: 35)
        self.avatarImageNode.cornerRadius = 25
        
        let leftSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.avatarImageNode, self.userNameTextNode])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [leftSpec, self.buttonNode])
        return ASInsetLayoutSpec.init(insets: self.contentInset, child:mainSpec)
    }
}

class AttentionUserListCellNode: ASCellNode, UserListCellNodeLayout {
    
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var userNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var buttonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    override init() {
        super.init()
        
        self.avatarImageNode.url = URL.init(string: "http://a.hiphotos.baidu.com/image/h%3D300/sign=c17af2b3bb51f819ee25054aeab54a76/d6ca7bcb0a46f21f46612acbfd246b600d33aed5.jpg")
        self.userNameTextNode.attributedText = "狂人包".attributedString
        self.buttonNode.setAttributedTitle("关注".withTextColor(Color.white), for: UIControlState.normal)
        self.buttonNode.backgroundColor = UIColor.pink
        
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.makeLayoutSpec()
    }
}
