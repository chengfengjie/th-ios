//
//  SystemMessageViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/31.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

class SystemMessageInfoCellNode: ASCellNode, SystemMessageInfoCellNodeLayout {
    
    fileprivate lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    fileprivate lazy var dateTimeTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    fileprivate lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    fileprivate lazy var messageInfoNode: UserInfoNode = {
        return UserInfoNode().then {
            self.addSubnode($0)
        }
    }()

    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.titleTextNode.attributedText = "家长必看的一个故事"
            .withFont(Font.systemFont(ofSize: 18))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create()
                .withAlignment(alignment: NSTextAlignment.center))
        
        self.dateTimeTextNode.attributedText = "2016.09.13"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 0, alignment: .center))
        
        self.contentTextNode.attributedText = "消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容"
            .withFont(Font.systemFont(ofSize: 14))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: .justified))
        
        self.messageInfoNode.backgroundColor = Color.hexColor(hex: "f5f5f5")
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.makeLayoutSpec()
    }
}

fileprivate protocol SystemMessageInfoCellNodeLayout: NodeElementMaker {
    var titleTextNode: ASTextNode { get }
    var dateTimeTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var messageInfoNode: UserInfoNode { get }
}
extension SystemMessageInfoCellNodeLayout {
    var contentInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 30, left: 30, bottom: 30, right: 30)
    }
    var infoSize: CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width - self.contentInset.left * 2, height: 60)
    }
    
    func makeLayoutSpec() -> ASLayoutSpec {
        self.messageInfoNode.style.preferredSize = self.infoSize
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.titleTextNode,
                                                         self.dateTimeTextNode,
                                                         self.contentTextNode,
                                                         self.messageInfoNode])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset,
                                                   child: mainSpec)
        
        return mainInsetSpec
    }
}

fileprivate class UserInfoNode: ASDisplayNode, NodeElementMaker {
    
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var infoTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.avatarImageNode.url = URL.init(string: "https://himg.bdimg.com/sys/portrait/item/45646779656f6e6c6565db09.jpg")
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 40, height: 40)
        self.avatarImageNode.cornerRadius = 20
        
        self.infoTextNode.attributedText = "《最好的教育》--是来自爸爸妈妈"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color3)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 10,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.avatarImageNode, self.infoTextNode])
        
        let vCenterSpec = ASRelativeLayoutSpec.init(horizontalPosition: ASRelativeLayoutSpecPosition.start,
                                                    verticalPosition: ASRelativeLayoutSpecPosition.center,
                                                    sizingOption: ASRelativeLayoutSpecSizingOption.minimumHeight,
                                                    child: mainSpec)
        
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15),
                                               child: vCenterSpec)
        return insetSpec
    }
    
}
