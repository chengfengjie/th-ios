//
//  MineViewCommentCellNodeLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/24.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

private let kContentInset: UIEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)

fileprivate protocol MineCommentCellNodeLayout {
    var commentTextNode: ASTextNode { get }
    var paragraphTextNode: ASTextNode { get }
    var sourceInfoBox: SourceInfoBox { get }
    var shareIconNode: ASImageNode { get }
    var shareTextNode: ASTextNode { get }
    var deleteButtonNode: ASButtonNode { get }
}

extension MineCommentCellNodeLayout where Self: ASCellNode {
    
    var commentTextStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.color = UIColor.color3
            $0.lineSpacing = 3
        }
    }
    
    var paragraphTextStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.color = Color.color6
            $0.lineSpacing = 5
            $0.alignment = NSTextAlignment.justified
        }
    }
    
    var shareDeleteTextStyle: TextStyle {
        return TextStyle().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.color = UIColor.color9
        }
    }
    
    func makeCommentTextNode() -> ASTextNode {
        return ASTextNode.init().then {
            self.addSubnode($0)
        }
    }
    func makeParagraphTextNode() -> ASTextNode {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }
    func makeSourceInfoBox() -> SourceInfoBox {
        return SourceInfoBox().then {
            self.addSubnode($0)
        }
    }
    func makeShareIconNode() -> ASImageNode {
        return ASImageNode().then {
            self.addSubnode($0)
        }
    }
    func makeShareTextNode() -> ASTextNode {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }
    func makeDeleteButtonNode() -> ASButtonNode {
        return ASButtonNode().then {
            self.addSubnode($0)
        }
    }
}

extension MineCommentCellNodeLayout {
    
    var hasParagraphText:Bool {
        if let attrText = self.paragraphTextNode.attributedText {
            return !attrText.string.isEmpty
        }
        return false
    }
    
    var commentCellNodeLayoutSpec: ASLayoutSpec {
        let shareDeleteSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                     spacing: 5,
                                                     justifyContent: ASStackLayoutJustifyContent.start,
                                                     alignItems: ASStackLayoutAlignItems.center,
                                                     children: [self.shareIconNode,
                                                                self.shareTextNode,
                                                                self.deleteButtonNode])
        
        var children: [ASLayoutElement] = [self.commentTextNode,
                                           self.sourceInfoBox,
                                           shareDeleteSpec]
        if self.hasParagraphText {
            children.insert(self.paragraphTextNode, at: 1)
        }
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: children)
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: kContentInset, child: mainSpec)
        return mainInsetSpec
    }
}

class SourceInfoBox: ASDisplayNode {
    
    lazy var imageNode: ASNetworkImageNode = {
        return ASNetworkImageNode.init().then {
            self.addSubnode($0)
        }
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    
    lazy var sourceTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    
    lazy var dateTimeTextNode: ASTextNode = {
        return ASTextNode().then {
            self.addSubnode($0)
        }
    }()
    
    override init() {
        super.init()
        
        self.style.preferredSize = CGSize.init(width: UIScreen.main.bounds.width - kContentInset.left * 2,
                                               height: 80)
        self.borderColor = UIColor.lineColor.cgColor
        self.borderWidth = CGFloat.pix1
        
        self.imageNode.style.preferredSize = CGSize.init(width: 50, height: 50)
        self.imageNode.url = URL.init(string: "https://pic2.zhimg.com/90/ba332a401_250x0.jpg")
        self.imageNode.backgroundColor = UIColor.orange
        
        self.titleTextNode.attributedText = "生个毛线的二胎".withFont(Font.systemFont(ofSize: 14))
        self.titleTextNode.maximumNumberOfLines = 1
        
        let width = self.style.preferredSize.width - (65 + kContentInset.left * 2)
        self.titleTextNode.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: width)
        
        self.sourceTextNode.attributedText = "文章来自简书".withTextColor(Color.color9).withFont(Font.systemFont(ofSize: 10))
        
        self.dateTimeTextNode.attributedText = "2018.1.1".withTextColor(Color.color9).withFont(Font.systemFont(ofSize: 10))

    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let sourceTimeSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: 0,
                                                    justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                    alignItems: ASStackLayoutAlignItems.center,
                                                    children: [self.sourceTextNode, self.dateTimeTextNode])
        let rightSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                               spacing: 18,
                                               justifyContent: ASStackLayoutJustifyContent.start,
                                               alignItems: ASStackLayoutAlignItems.stretch,
                                               children: [self.titleTextNode, sourceTimeSpec])
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.imageNode, rightSpec])
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: kContentInset, child: mainSpec)
        return mainInsetSpec
    }
}

class MineCommentNodeCell: ASCellNode, MineCommentCellNodeLayout, NodeBottomlineMaker {

    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomlineNode()
    }()

    fileprivate lazy var commentTextNode: ASTextNode = {
        return self.makeCommentTextNode()
    }()
    
    fileprivate lazy var paragraphTextNode: ASTextNode = {
        return self.makeParagraphTextNode()
    }()
    
    fileprivate lazy var sourceInfoBox: SourceInfoBox = {
        return self.makeSourceInfoBox()
    }()
    
    fileprivate lazy var shareIconNode: ASImageNode = {
        return self.makeShareIconNode()
    }()
    
    fileprivate lazy var shareTextNode: ASTextNode = {
        return self.makeShareTextNode()
    }()
    
    fileprivate lazy var deleteButtonNode: ASButtonNode = {
        return self.makeDeleteButtonNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.bottomline.backgroundColor = UIColor.lineColor
        
        self.shareIconNode.style.preferredSize = CGSize.init(width: 16, height: 16)
        
        self.commentTextNode.setText(text: dataJSON["message"]["msg"].stringValue, style: self.commentTextStyle)
        self.paragraphTextNode.setText(text: dataJSON["message"]["quote"].stringValue, style: self.paragraphTextStyle)
        self.sourceInfoBox.backgroundColor = UIColor.white
        self.sourceInfoBox.imageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.sourceInfoBox.imageNode.defaultImage = UIImage.defaultImage
        self.sourceInfoBox.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withFont(Font.systemFont(ofSize: 14))
        self.sourceInfoBox.sourceTextNode.attributedText = "来自:\(dataJSON["from"].stringValue)"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 10))
        
        self.shareIconNode.image = UIImage.init(named: "mine_share_gray")
        self.shareTextNode.setText(text: "分享", style: self.shareDeleteTextStyle)
        self.deleteButtonNode.setTitleText(text: "删除", style: self.shareDeleteTextStyle)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.makeBottomlineWraperSpec(mainSpec: self.commentCellNodeLayoutSpec)
    }
}


