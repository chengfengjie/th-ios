//
//  EditUserInfoViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/25.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol EditUserInfoViewLayout {
    
}
extension EditUserInfoViewLayout {
    
}

class EditUserAvatarCellNode: ASCellNode, NodeElementMaker, NodeBottomlineMaker {
    
    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomlineNode()
    }()
    
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    override init() {
        super.init()
        self.avatarImageNode.defaultImage = UIImage.defaultImage
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 80, height: 80)
        self.avatarImageNode.cornerRadius = 40
        self.selectionStyle = .none
        
        self.bottomline.backgroundColor = UIColor.lineColor
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let avatarSpec = ASCenterLayoutSpec.init(centeringOptions: ASCenterLayoutSpecCenteringOptions.XY,
                                sizingOptions: ASCenterLayoutSpecSizingOptions.minimumXY,
                                child: self.avatarImageNode)
        let mainSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 0, bottom: 40, right: 0),
                                      child: avatarSpec)
        return self.makeBottomlineWraperSpec(mainSpec: mainSpec)
    }
    
}

class EditUserInfoTextNode: ASCellNode, NodeElementMaker, NodeBottomlineMaker {
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var valueTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomlineNode()
    }()
    
    init(title: String, value: String) {
        super.init()
        
        self.titleTextNode.attributedText = title
            .withFont(Font.sys(size: 14))
            .withTextColor(Color.color6)
        self.titleTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: 80)
        
        self.valueTextNode.attributedText = value
            .withTextColor(Color.color3)
            .withFont(Font.sys(size: 14))
        let width: CGFloat = UIScreen.main.bounds.width - 120
        self.valueTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: width)
        
        self.bottomline.backgroundColor = UIColor.lineColor
        self.selectionStyle = .none
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                          spacing: 0,
                                          justifyContent: ASStackLayoutJustifyContent.start,
                                          alignItems: ASStackLayoutAlignItems.center,
                                          children: [self.titleTextNode, self.valueTextNode])
        let inset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20),
                                           child: spec)
        return self.makeBottomlineWraperSpec(mainSpec: inset)
    }
    
}
