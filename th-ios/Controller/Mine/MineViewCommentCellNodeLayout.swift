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
    var commentCellNodeLayoutSpec: ASLayoutSpec {
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.commentTextNode, self.paragraphTextNode, self.sourceInfoBox])
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
        self.borderWidth = 1
        
        self.imageNode.style.preferredSize = CGSize.init(width: 50, height: 50)
        self.imageNode.url = URL.init(string: "https://pic2.zhimg.com/90/ba332a401_250x0.jpg")
        self.imageNode.backgroundColor = UIColor.orange
        
        self.titleTextNode.attributedText = "生个毛线的二胎".attributedString
        
        self.sourceTextNode.attributedText = "文章来自简书".attributedString
        
        self.dateTimeTextNode.attributedText = "2018.1.1".attributedString

    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let sourceTimeSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                    spacing: 10,
                                                    justifyContent: ASStackLayoutJustifyContent.spaceAround,
                                                    alignItems: ASStackLayoutAlignItems.center,
                                                    children: [self.sourceTextNode, self.dateTimeTextNode])
        let rightSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                               spacing: 10,
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

class MineCommentTopicNodeCell: ASCellNode, MineCommentCellNodeLayout {
    
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
    
    override init() {
        super.init()
        
        self.commentTextNode.attributedText = "说的不错,确实如此".attributedString
        self.paragraphTextNode.attributedText = ("自从换了mac以后就一直用EdrawMax，不仅可以代替Visio，而且" +
        "功能方面要比Visio更加强大，不仅可以画流程图，就连服装设计，科学插画，卡片这些都可以绘制" +
        "，真是一个软件可以当好几个软件来用，操作也特别简单。").attributedString
        self.sourceInfoBox.backgroundColor = UIColor.white
        self.shareIconNode.image = UIImage.init(named: "mine_share_gray")
        self.shareTextNode.attributedText = "分享".attributedString
        self.deleteButtonNode.setAttributedTitle("删除".attributedString, for: UIControlState.normal)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.commentCellNodeLayoutSpec
    }
}


