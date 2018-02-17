//
//  ReaderLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/11.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

/// 阅读器底部评论点赞操作Bar
class ReaderBottomBar: NSObject {
    let goodItem: UIButton
    let commentItem: UIButton
    let commentTotalItem: UIButton
    init(goodItem: UIButton,
         commentItem: UIButton,
         commentTotalItem: UIButton) {
        self.goodItem = goodItem
        self.commentItem = commentItem
        self.commentTotalItem = commentTotalItem
        super.init()
    }
}

protocol ReaderLayout {
    var bottomBar: ReaderBottomBar { get }
    var content: UIView { get }
}
extension ReaderLayout {
    
    func makeAndLayoutReaderBottomBar() -> ReaderBottomBar {
        let container: UIView = UIView().then {
            $0.backgroundColor = UIColor.white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize.init(width: 0, height: -5)
            $0.layer.shadowRadius = 8
            $0.layer.shadowOpacity = 0.2
            self.content.addSubview($0)
        }
        container.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(55)
        }
        
        let goodItem: UIButton = UIButton.init(type: .custom).then {
            $0.setImage(UIImage.init(named: "qing_like_dark_gray"), for: UIControlState.normal)
            $0.setImage(UIImage.init(named: "qing_like_color"), for: UIControlState.selected)
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.width.height.equalTo(24)
                make.centerY.equalTo(container.snp.centerY)
            })
        }
        
        let commentItem: UIButton = UIButton.init(type: .custom).then {
            container.addSubview($0)
            $0.backgroundColor = UIColor.hexColor(hex: "f6f6f6")
            $0.layer.borderColor = UIColor.lineColor.cgColor
            $0.layer.borderWidth = CGFloat.pix1
            $0.layer.cornerRadius = 5
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(goodItem.snp.right).offset(15)
                make.right.equalTo(-100)
                make.height.equalTo(35)
                make.centerY.equalTo(container.snp.centerY)
            })
            
            let box = $0
            UILabel.init().do({ (label) in
                box.addSubview(label)
                label.text = "说点什么"
                label.font = UIFont.sys(size: 13)
                label.textColor = UIColor.color9
                label.snp.makeConstraints({ (make) in
                    make.left.equalTo(10)
                    make.centerY.equalTo(box.snp.centerY)
                })
                
            })
        }
        
        let commentTotalItem: UIButton = UIButton.init(type: .custom).then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(container.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(70)
            })
            $0.layer.borderWidth = CGFloat.pix1
            $0.layer.borderColor = UIColor.lineColor.cgColor
            $0.setTitle("1/123", for: UIControlState.normal)
            $0.setTitleColor(UIColor.color9, for: UIControlState.normal)
            $0.titleLabel?.font = UIFont.sys(size: 12)
            $0.layer.cornerRadius = 5
        }
        
        return ReaderBottomBar.init(goodItem: goodItem,
                                    commentItem: commentItem,
                                    commentTotalItem: commentTotalItem)
    }
}


class ReaderContentCellNode: ASCellNode, ReaderContentCellNodeLayout {
    
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
    
    var paragraphContentlist: [ReaderContentElement] = []
    
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

class ReaderContentElement: NSObject {
    
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

protocol ReaderContentCellNodeLayout: NodeElementMaker {
    var titleTextNode: ASTextNode { get }
    var authorAvatarImageNode: ASNetworkImageNode { get }
    var authorTextNode: ASTextNode { get }
    var attendButtonNode: ASButtonNode { get }
    var paragraphContentlist: [ReaderContentElement] { get }
    var sourceContainer: SourceContainer { get }
    var feedbackTextNode: ASTextNode { get }
}

extension ReaderContentCellNodeLayout where Self: ASCellNode {
    
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
    
    func createParagraphContent(datalist: [JSON]) -> [ReaderContentElement] {
        var list: [ReaderContentElement] = []
        datalist.forEach { (data) in
            if data["type"].stringValue == "0" {
                list.append(self.createTextNode(data: data))
            } else if data["type"].stringValue == "1" {
                list.append(self.createImageNode(data: data))
            }
        }
        return list
    }
    
    func createTextNode(data: JSON) -> ReaderContentElement {
        let textNode: ASTextNode = self.makeAndAddTextNode().then {
            $0.attributedText = data["text"]["text"].stringValue
                .withTextColor(Color.color3).withFont(Font.thin(size: 16))
                .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        }
        
        return ReaderContentElement.init(type: .text, data: data, node: textNode)
    }
    
    func createImageNode(data: JSON) -> ReaderContentElement {
        let imageNode: ASNetworkImageNode = self.makeAndAddNetworkImageNode().then {
            $0.url = URL.init(string: data["image"]["source"].stringValue)
            $0.defaultImage = UIImage.defaultImage
            $0.style.preferredSize = self.getImageSize(imageDataJSON: data["image"])
        }
        return ReaderContentElement.init(type: .image, data: data, node: imageNode)
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
