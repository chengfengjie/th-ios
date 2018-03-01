//
//  MessageListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

protocol MessageListViewLayout {
    var headerChangeControl: HeaderChangeControl { get }
}
extension MessageListViewLayout where Self: MessageListViewController {
    var headerChangeControlSize: CGSize {
        return CGSize.init(width: self.window_width, height: 45)
    }
    func makeHeaderChangeControl() -> HeaderChangeControl {
        return HeaderChangeControl().then {
            $0.titles = ["系统", "私信"]
            $0.bottomlineWidth = self.window_width / 2 - 30
            $0.frame = CGRect.init(origin: CGPoint.zero, size: self.headerChangeControlSize)
        }
    }
}

class PrivateMessageListCellNode: ASCellNode, PrivateMessageListCellNodeLayout {
    
    lazy var userAvatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var userNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var dateTimeTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var contentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var indicatorImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.userAvatarImageNode.url = URL.init(string: dataJSON["img"].stringValue)
        self.userAvatarImageNode.style.preferredSize = CGSize.init(width: 40, height: 40)
        self.userAvatarImageNode.cornerRadius = 20
        self.userAvatarImageNode.defaultImage = UIImage.defaultImage
        
        self.userNameTextNode.attributedText = dataJSON["nickname"].stringValue
            .withFont(Font.systemFont(ofSize: 18))
            .withTextColor(Color.color3)
        
        self.dateTimeTextNode.attributedText = dataJSON["dateline"].stringValue
            .dateFormat(type: DateFormatType.yymmdd)
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 10))
        
        self.contentTextNode.attributedText = dataJSON["message"].stringValue
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: .justified))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.makeLayoutSpec()
    }
    
}

protocol PrivateMessageListCellNodeLayout: NodeElementMaker {
    var userAvatarImageNode: ASNetworkImageNode { get }
    var userNameTextNode: ASTextNode { get }
    var dateTimeTextNode: ASTextNode { get }
    var contentTextNode: ASTextNode { get }
    var indicatorImageNode: ASImageNode { get }
}
extension PrivateMessageListCellNodeLayout where Self: ASCellNode {
    
    func makeLayoutSpec() -> ASLayoutSpec {
        let nameTimeSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                  spacing: 5,
                                                  justifyContent: ASStackLayoutJustifyContent.start,
                                                  alignItems: ASStackLayoutAlignItems.stretch,
                                                  children: [self.userNameTextNode, self.dateTimeTextNode])
        let avatarNameSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: 10,
                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                    alignItems: ASStackLayoutAlignItems.center,
                                                    children: [self.userAvatarImageNode, nameTimeSpec])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [avatarNameSpec, self.contentTextNode])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.makeDefaultContentInset(), child: mainSpec)
        return mainInsetSpec
    }
    
}

class SystemMessageListCellNode: ASCellNode, SystemMessageListCellNodeLayout {
    
    lazy var dateTimeTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var deleteButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    lazy var noticeDotNode: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    lazy var contentNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.dateTimeTextNode.attributedText = dataJSON["dateline"].stringValue
            .dateFormat(type: .yymmdd)
            .withFont(Font.systemFont(ofSize: 10))
            .withTextColor(Color.color9)
        
        self.noticeDotNode.style.preferredSize = CGSize.init(width: 5, height: 5)
        self.noticeDotNode.cornerRadius = 2.5
        self.noticeDotNode.backgroundColor = UIColor.pink
        
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withTextColor(Color.color3)
            .withFont(Font.systemFont(ofSize: 18))
        
        self.deleteButtonNode.setAttributedTitle("删除"
            .withFont(Font.systemFont(ofSize: 16))
            .withTextColor(Color.color9), for: UIControlState.normal)
        
        self.contentNode.attributedText = dataJSON["val"].stringValue
            .withTextColor(Color.color6)
            .withFont(Font.systemFont(ofSize: 14))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: .justified))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.makeLayoutSpec()
    }
}

protocol SystemMessageListCellNodeLayout: NodeElementMaker {
    var dateTimeTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var deleteButtonNode: ASButtonNode { get }
    var noticeDotNode: ASDisplayNode { get }
    var contentNode: ASTextNode { get }
}
extension SystemMessageListCellNodeLayout {
    
    func makeLayoutSpec() -> ASLayoutSpec {
        
        self.noticeDotNode.style.layoutPosition = CGPoint.init(x: 30, y: 65)
        
        let titleDeleteSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                     spacing: 0,
                                                     justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                     alignItems: ASStackLayoutAlignItems.center,
                                                     children: [self.titleTextNode, self.deleteButtonNode])
        
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 15,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [self.dateTimeTextNode, titleDeleteSpec, self.contentNode])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 30, left: 50, bottom: 30, right: 30), child: contentSpec)
        
        let dotSpec = ASAbsoluteLayoutSpec.init(sizing: ASAbsoluteLayoutSpecSizing.sizeToFit, children: [self.noticeDotNode])
        
        
        return ASWrapperLayoutSpec.init(layoutElements: [mainInsetSpec, dotSpec])
        
    }
    
}






