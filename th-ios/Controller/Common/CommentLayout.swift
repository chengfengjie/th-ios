//
//  CommentLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol CommentLayout {
    var textView: UITextView { get }
    var content: UIView { get }
}
extension CommentLayout {
    
    func createTextView() -> UITextView {
        return UITextView.init().then {
            self.content.addSubview($0)
            $0.font = UIFont.sys(size: 14)
            $0.textColor = UIColor.color3
            $0.autocorrectionType = .no
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(80)
                make.left.equalTo(17)
                make.right.equalTo(-17)
                make.height.equalTo(100)
            })
        }
    }
}

class CommentCellNode: ASCellNode, CommentCellNodeLayout {
    
    lazy var avatar: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var nameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var dateTimeTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var goodButtonNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var goodTotalTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var commentTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var reportButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    lazy var replyButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    lazy var bottomline: ASDisplayNode = {
        return ASDisplayNode().then {
            self.addSubnode($0)
        }
    }()
    
    var replyNodes: [CommentReplyNode] = []
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.bottomline.backgroundColor = UIColor.lineColor
        self.bottomline.style.height = ASDimension.init(unit: ASDimensionUnit.points, value: CGFloat.pix1)
        
        self.avatar.url = URL.init(string: "http://g.hiphotos.baidu.com/image/h%3D300/sign=0760ea1c811363270aedc433a18da056/11385343fbf2b21185acf38ec18065380dd78e6b.jpg")
        self.avatar.style.preferredSize = self.avatarSize
        self.avatar.cornerRadius = self.avatarSize.width / 2.0
        
        self.nameTextNode.attributedText = "初恋在线"
            .withFont(Font.sys(size: 14))
            .withTextColor(Color.pink)
        
        self.dateTimeTextNode.attributedText = "今天 14:52"
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 10))
        
        self.goodButtonNode.image = UIImage.init(named: "qing_like_dark_gray")
        self.goodButtonNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        
        self.goodTotalTextNode.attributedText = "12"
            .withFont(.sys(size: 12))
            .withTextColor(Color.color9)
        
        self.commentTextNode.attributedText = "世界应为啊实打实的拉斯肯德基拉萨的奥斯卡的骄傲了实打实肯德基埃里克圣诞节爱丽丝大来说都".withTextColor(Color.color3).withFont(Font.sys(size: 16))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: NSTextAlignment.justified))
        self.commentTextNode.style.width = ASDimension.init(unit: .points, value: self.rightContentMaxWidth)
        
        self.reportButtonNode.setAttributedTitle("举报".withFont(Font.sys(size: 10)).withTextColor(Color.color9),
                                                for: UIControlState.normal)
        
        self.replyButtonNode.setAttributedTitle("回复".withFont(Font.sys(size: 10)).withTextColor(Color.color9),
                                                for: UIControlState.normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let lineInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20),
                                                   child: self.bottomline)
        
        return ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                      spacing: 0,
                                      justifyContent: ASStackLayoutJustifyContent.start,
                                      alignItems: ASStackLayoutAlignItems.center,
                                      children: [self.makeLayoutSpec(), lineInsetSpec])
        
    }
}

class CommentReplyNode {
    var line: ASDisplayNode!
    var nickName: ASTextNode!
    var datetime: ASTextNode!
    var content: ASTextNode!
}

protocol CommentCellNodeLayout: NodeElementMaker {
    var avatar: ASNetworkImageNode { get }
    var nameTextNode: ASTextNode { get }
    var dateTimeTextNode: ASTextNode { get }
    var goodButtonNode: ASImageNode { get }
    var goodTotalTextNode: ASTextNode { get }
    var commentTextNode: ASTextNode { get }
    var reportButtonNode: ASButtonNode { get }
    var replyButtonNode: ASButtonNode { get }
    
    var replyNodes: [CommentReplyNode] { get }
}

extension CommentCellNodeLayout {
    
    var avatarSize: CGSize {
        return CGSize.init(width: 40, height: 40)
    }

    var contentInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    var elementSpacing: CGFloat {
        return 10.0
    }
    
    var rightContentMaxWidth: CGFloat {
        return UIScreen.main.bounds.width - self.contentInset.left
            - self.contentInset.right - self.avatarSize.width - self.elementSpacing
    }
    
    func makeLayoutSpec() -> ASLayoutSpec {
        let avatarDateTimeSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                        spacing: 5,
                                                        justifyContent: ASStackLayoutJustifyContent.start,
                                                        alignItems: ASStackLayoutAlignItems.stretch,
                                                        children: [self.nameTextNode, self.dateTimeTextNode])
        
        let goodTotalSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                   spacing: 5,
                                                   justifyContent: ASStackLayoutJustifyContent.start,
                                                   alignItems: ASStackLayoutAlignItems.center,
                                                   children: [self.goodButtonNode, self.goodTotalTextNode])
        
        let avatarGoodInfoSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                        spacing: 0,
                                                        justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                        alignItems: ASStackLayoutAlignItems.center,
                                                        children: [avatarDateTimeSpec])
        
        let reportReplySpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                     spacing: 0,
                                                     justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                     alignItems: ASStackLayoutAlignItems.center,
                                                     children: [self.replyButtonNode, goodTotalSpec])
        
        var vContentSpecs:[ASLayoutElement] = [avatarGoodInfoSpec, self.commentTextNode]
        
        var replyElements: [ASLayoutElement] = []
        self.replyNodes.forEach { (item) in
            replyElements.append(makeReplyCommentNodeSpec(node: item))
        }
        
        let replyLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                     spacing: 0,
                                                     justifyContent: ASStackLayoutJustifyContent.start,
                                                     alignItems: ASStackLayoutAlignItems.stretch,
                                                     children: replyElements)
        vContentSpecs.append(replyLayoutSpec)
        
        vContentSpecs.append(reportReplySpec);
        
        let rightContentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                      spacing: 15,
                                                      justifyContent: ASStackLayoutJustifyContent.start,
                                                      alignItems: ASStackLayoutAlignItems.stretch,
                                                      children: vContentSpecs)
        
        let avatarContentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                       spacing: 15,
                                                       justifyContent: ASStackLayoutJustifyContent.start,
                                                       alignItems: ASStackLayoutAlignItems.stretch,
                                                       children: [self.avatar, rightContentSpec])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 15, bottom: 20, right: 15),
                                                   child: avatarContentSpec)
        
        return mainInsetSpec
    }
    
    func makeReplyCommentNodeSpec(node: CommentReplyNode) -> ASLayoutSpec {
        let nameDateTimeSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                      spacing: 7,
                                                      justifyContent: ASStackLayoutJustifyContent.start,
                                                      alignItems: ASStackLayoutAlignItems.center,
                                                      children: [node.nickName, node.datetime])
        let contentSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                 spacing: 10,
                                                 justifyContent: ASStackLayoutJustifyContent.start,
                                                 alignItems: ASStackLayoutAlignItems.stretch,
                                                 children: [nameDateTimeSpec, node.content])
        
        let contentInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 0), child: contentSpec)
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [node.line, contentInset])
        
        return mainSpec
    }
}
