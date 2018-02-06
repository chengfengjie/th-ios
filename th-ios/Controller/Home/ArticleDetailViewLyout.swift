//
//  ArticleDetailViewLyout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class ArticleContentCellNode: ASCellNode, ArticleTopicContentCellNodeLayout {
    
    lazy var sourceContainer: SourceContainer = {
        return self.makeSourceContainer(dataJSON: self.dataJSON)
    }()
   
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var authorAvatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var authorTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var attendButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    lazy var feedbackTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    var paragraphContentlist: [ArticleTopicContentParagraph] = []

    let dataJSON: JSON
    
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.selectionStyle = .none
        
        self.titleTextNode.attributedText = dataJSON["sTitle"].stringValue
            .withFont(Font.sys(size: 20))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        
        self.authorAvatarImageNode.url = URL.init(string: dataJSON["sAvatar"].stringValue)
        self.authorAvatarImageNode.style.preferredSize = CGSize.init(width: 24, height: 24)
        self.authorAvatarImageNode.cornerRadius = 12
        self.authorAvatarImageNode.defaultImage = UIImage.defaultImage
        
        self.authorTextNode.attributedText = dataJSON["sAuthor"].stringValue
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.pink)
        
        self.attendButtonNode.style.preferredSize = CGSize.init(width: 70, height: 26)
        self.attendButtonNode.setAttributedTitle("+ 关注"
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.pink), for: UIControlState.normal)
        self.attendButtonNode.borderColor = UIColor.pink.cgColor
        self.attendButtonNode.borderWidth = 1
        
        self.paragraphContentlist = self.createParagraphContent(datalist: dataJSON["sContent"].arrayValue)
        
        self.sourceContainer.borderColor = UIColor.lineColor.cgColor
        self.sourceContainer.borderWidth = 1.0 / UIScreen.main.scale

        let tipAttributeText = ("本页面由童伙妈妈应用采用内搜索技术自动抓取，在未编辑原始内容的情况下对板式做了优化提升阅读体验·"
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 14)) + "版权举报".withFont(Font.boldSystemFont(ofSize: 14))).withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: NSTextAlignment.justified))
        self.feedbackTextNode.attributedText = "页面排版有问题?"
            .withFont(Font.sys(size: 14))
            .withTextColor(Color.color9) + " 报错\n\n".withFont(Font.sys(size: 14)) + tipAttributeText
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
}

class ArticleTopicContentParagraph: NSObject {
    
    enum ContentType {
        case text
        case image
        case audio
        case video
    }
    
    var type: ContentType
    
    var node: ASDisplayNode
    
    var noteNode: ASDisplayNode = ASDisplayNode()
    
    var data: JSON
    
    init(type: ContentType, data: JSON, node: ASDisplayNode) {
        self.data = data
        self.type = type
        self.node = node
        super.init()
    }
    
}

protocol ArticleTopicContentCellNodeLayout: NodeElementMaker {
    
    var titleTextNode: ASTextNode { get }
    var authorAvatarImageNode: ASNetworkImageNode { get }
    var authorTextNode: ASTextNode { get }
    var attendButtonNode: ASButtonNode { get }
    var paragraphContentlist: [ArticleTopicContentParagraph] { get }
    var sourceContainer: SourceContainer { get }
    var feedbackTextNode: ASTextNode { get }
}

extension ArticleTopicContentCellNodeLayout where Self: ASCellNode {
    
    var contentInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    var contentWidth: CGFloat {
        return UIScreen.main.bounds.width - self.contentInset.left - self.contentInset.right
    }
    
    func makeSourceContainer(dataJSON: JSON) -> SourceContainer {
        return SourceContainer.init(sourceName: dataJSON["sAuthor"].stringValue).then {
            self.addSubnode($0)
            $0.style.preferredSize = CGSize.init(width: contentWidth, height: 60)
        }
    }
    
    func createParagraphContent(datalist: [JSON]) -> [ArticleTopicContentParagraph] {
        var list: [ArticleTopicContentParagraph] = []
        datalist.forEach { (data) in
            if data["type"].stringValue == "0" {
                list.append(self.createTextNode(data: data))
            } else if data["type"].stringValue == "1" {
                list.append(self.createImageNode(data: data))
            }
        }
        return list
    }
    
    func createTextNode(data: JSON) -> ArticleTopicContentParagraph {
        let textNode: ASTextNode = self.makeAndAddTextNode().then {
            $0.attributedText = data["text"]["text"].stringValue
                .withTextColor(Color.color3).withFont(Font.thin(size: 16))
                .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        }
        
        return ArticleTopicContentParagraph.init(type: .text, data: data, node: textNode)
    }
    
    func createImageNode(data: JSON) -> ArticleTopicContentParagraph {
        let imageNode: ASNetworkImageNode = self.makeAndAddNetworkImageNode().then {
            $0.url = URL.init(string: data["image"]["source"].stringValue)
            $0.defaultImage = UIImage.defaultImage
            $0.style.preferredSize = self.getImageSize(imageDataJSON: data["image"])
        }
        return ArticleTopicContentParagraph.init(type: .image, data: data, node: imageNode)
    }
    
    private func getImageSize(imageDataJSON: JSON) -> CGSize {
        let imageWidth: CGFloat = imageDataJSON["width"].floatValue.cgFloat
        let imageHeight: CGFloat = imageDataJSON["height"].floatValue.cgFloat
        let viewWidth: CGFloat = UIScreen.main.bounds.width - self.contentInset.left - self.contentInset.right
        let viewHeight: CGFloat = viewWidth * (imageHeight / imageWidth)
        return CGSize.init(width: viewWidth, height: viewHeight)
    }
    
    func buildLayoutSpec() -> ASLayoutSpec {
        let authorSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: 5,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.center,
                                                children: [self.authorAvatarImageNode, self.authorTextNode])
        let authorInfoBarSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                       spacing: 0,
                                                       justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                       alignItems: ASStackLayoutAlignItems.center,
                                                       children: [authorSpec, self.attendButtonNode])
        
        let contentlist: [ASDisplayNode] = self.paragraphContentlist.map { (t) -> ASDisplayNode in
            return t.node
        }
        
        var children: [ASLayoutElement] = [self.titleTextNode, authorInfoBarSpec] + contentlist
        children.append(ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(20, 0, 0, 0), child: self.sourceContainer))
        children.append(self.feedbackTextNode)
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: children)
        
        let mainInsetSpec = ASInsetLayoutSpec.init(insets: self.contentInset,
                                                   child: mainSpec)
        
        return mainInsetSpec
        
    }
    
}

/// 来自: xxx 的那一块node
class SourceContainer: ASControlNode, NodeElementMaker {
    
    lazy var textNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var indicator: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    init(sourceName: String) {
        super.init()
        
        self.backgroundColor = UIColor.hexColor(hex: "fbfbfb")
        
        self.textNode.attributedText = "来自: "
            .withTextColor(Color.color3)
            .withFont(Font.sys(size: 16)) + sourceName
                .withFont(Font.sys(size: 16))
                .withTextColor(Color.pink)
        
        self.indicator.image = UIImage.init(named: "qing_right")
        self.indicator.style.preferredSize = CGSize.init(width: 14, height: 14)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let position = ASRelativeLayoutSpec.init(horizontalPosition: ASRelativeLayoutSpecPosition.start,
                                                 verticalPosition: ASRelativeLayoutSpecPosition.center,
                                                 sizingOption: ASRelativeLayoutSpecSizingOption.minimumSize,
                                                 child: self.textNode)
        
        let contentInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 90),
                                                  child: position)
        
        let indicatorSpec = ASRelativeLayoutSpec.init(horizontalPosition: ASRelativeLayoutSpecPosition.end,
                                                      verticalPosition: ASRelativeLayoutSpecPosition.center,
                                                      sizingOption: ASRelativeLayoutSpecSizingOption.minimumSize,
                                                      child: self.indicator)
        
        let incatorInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20),
                                                  child: indicatorSpec)
        return ASWrapperLayoutSpec.init(layoutElements: [contentInset, incatorInset])
    }
}


class ArticleRelatedCellNode: NoneContentArticleCellNodeImpl {
 
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.showCateTextNode = false
        
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withTextColor(Color.color3)
            .withFont(Font.thin(size: 18))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        self.titleTextNode.maximumNumberOfLines = 2
        self.titleTextNode.truncationMode = .byTruncatingTail
        
        self.sourceIconImageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.sourceIconImageNode.defaultImage = UIImage.defaultImage
        
        self.sourceTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color3)
        
        self.unlikeButtonNode.setAttributedTitle("不喜欢"
            .withFont(Font.sys(size: 12))
            .withTextColor(Color.color6), for: UIControlState.normal)
        
        self.imageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.imageNode.defaultImage = UIImage.defaultImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if self.dataJSON["pic"].stringValue.isEmpty {
            return self.buildNoneImageLayoutSpec(constrainedSize: constrainedSize)
        } else {
            return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
        }
    }
}
