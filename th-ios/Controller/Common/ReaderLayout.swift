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
                make.width.height.equalTo(18)
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
                label.text = "评论文章"
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
            $0.setTitle("0评论", for: UIControlState.normal)
            $0.setTitleColor(UIColor.color9, for: UIControlState.normal)
            $0.titleLabel?.font = UIFont.sys(size: 12)
            $0.layer.cornerRadius = 5
        }
        
        return ReaderBottomBar.init(goodItem: goodItem,
                                    commentItem: commentItem,
                                    commentTotalItem: commentTotalItem)
    }
}


class ReaderContentCellNode: ASCellNode, ReaderContentCellNodeLayout, ReaderContentElementAction, RootNavigationControllerProtocol {
    
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
    
    fileprivate lazy var editMenu: EditMenu = {
        let frame = CGRect.init(x: 20, y: 100, width: UIScreen.main.bounds.width-40, height: 55)
        return EditMenu.init(frame: frame)
    }()
    
    var paragraphContentlist: [ReaderContentElement] = []
    
    var currentContentElement: ReaderContentElement? = nil
    
    let dataJSON: JSON
    
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.selectionStyle = .none
        
        self.titleTextNode.attributedText = dataJSON["title"].stringValue
            .withFont(Font.sys(size: 23))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        
        self.authorAvatarImageNode.url = URL.init(string: dataJSON["userAvatar"].stringValue)
        self.authorAvatarImageNode.style.preferredSize = CGSize.init(width: 20, height: 20)
        self.authorAvatarImageNode.cornerRadius = 10
        self.authorAvatarImageNode.defaultImage = UIImage.defaultImage
        
        self.authorTextNode.attributedText = dataJSON["userName"].stringValue
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.pink)
        
        self.attendButtonNode.style.preferredSize = CGSize.init(width: 88, height: 32)
        self.attendButtonNode.setAttributedTitle("+ 关注作者"
            .withFont(Font.sys(size: 13))
            .withTextColor(Color.pink), for: UIControlState.normal)
        self.attendButtonNode.borderColor = UIColor.pink.cgColor
        self.attendButtonNode.borderWidth = 1
        self.attendButtonNode.cornerRadius = 3
        
        self.paragraphContentlist = self.createParagraphContent(datalist: dataJSON["sections"].arrayValue)
        
        self.sourceContainer.borderColor = UIColor.lineColor.cgColor
        self.sourceContainer.borderWidth = CGFloat.pix1
        
        let tipAttributeText = ("本页面由轻阅APP应用采用内搜索技术自动抓取，在未编辑原始内容的情况下对板式做了优化提升阅读体验·"
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 14)) + "版权举报".withFont(Font.boldSystemFont(ofSize: 14)))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: NSTextAlignment.justified))
        
        self.feedbackTextNode.attributedText = "页面排版有问题?"
            .withFont(Font.sys(size: 14))
            .withTextColor(Color.color9) + " 报错\n\n".withFont(Font.sys(size: 14)) + tipAttributeText
        
        self.editMenu.noteButton?.reactive.controlEvents(.touchUpInside).observeValues({ [weak self] (sender) in
            self?.clickMenuEdit()
        })
        
        self.editMenu.deleteButton?.reactive.controlEvents(.touchUpInside).observeValues({ [weak self] (sender) in
            self?.clickMenuMoreNote()
        })
        
        self.editMenu.copyButton?.reactive.controlEvents(.touchUpInside).observeValues({ [weak self] (sender) in
            self?.clickMenuCopy()
        })
        
        self.editMenu.shareButton?.reactive.controlEvents(.touchUpInside).observeValues({ [weak self] (sender) in
            self?.clickMenuShare()
        })
        
        self.bindAction()
    }
    
    func bindAction() {
        self.paragraphContentlist.forEach { (element) in
            element.action = self
        }
    }
    
    var pressElement: ReaderContentElement?
    
    func readerContentDidLongPressNode(element: ReaderContentElement) {
        if self.currentContentElement != nil {
            self.currentContentElement?.node.backgroundColor = UIColor.white
        }
        DispatchQueue.main.async {
            self.pressElement = element
            element.node.backgroundColor = UIColor.paraBgColor
            var editMenuCenter = self.editMenu.center
            let point = element.node.convert(CGPoint.zero, to: self)
            editMenuCenter.y = point.y - 50
            self.editMenu.center = editMenuCenter
            self.view.addSubview(self.editMenu)
            self.currentContentElement = element
            self.editMenuDidShow()
            
        }
    }
    
    func editMenuDidShow() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
    
    func didScroll() {
        self.editMenu.removeFromSuperview()
        self.currentContentElement?.node.backgroundColor = UIColor.white
        self.currentContentElement = nil
    }
    
    func clickMenuEdit() {
        
    }
    
    func clickMenuMoreNote() {}
    
    func deleteNoteSuccess(element: ReaderContentElement) {
        self.editMenu.removeFromSuperview()
    }
    
    func clickMenuCopy() {
    
    }
    
    func clickMenuShare() {
        
    }
    
    func hideMenu() {
        self.editMenu.removeFromSuperview()
    }
}

protocol ReaderContentElementAction {
    func readerContentDidLongPressNode(element: ReaderContentElement)
}

class ReaderContentElement: NSObject {
    
    var action: ReaderContentElementAction? = nil
    
    enum ContentType {
        case text
        case image
        case audio
        case video
    }
    
    var type: ContentType
    
    var node: ASControlNode
    
    var data: JSON
    
    var markups: Bool = true
    
    var noteText: String = ""
    
    init(type: ContentType, data: JSON, node: ASControlNode) {
        self.data = data
        self.type = type
        self.node = node
        super.init()
        
        self.node.addTarget(self, action: #selector(self.pressNode(sender:)), forControlEvents: .touchUpInside)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            self.node.isUserInteractionEnabled = true
        })
    }
    
    @objc func pressNode(sender: ASControlNode) {
        self.action?.readerContentDidLongPressNode(element: self)
    }
    
    @objc func handleClickNode() {

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
        return SourceContainer.init(sourceName: dataJSON["sourceTypeName"].stringValue).then {
            self.addSubnode($0)
            $0.style.preferredSize = CGSize.init(width: contentWidth, height: 60)
        }
    }
    
    func createParagraphContent(datalist: [JSON]) -> [ReaderContentElement] {
        var list: [ReaderContentElement] = []
        datalist.forEach { (data) in
            if data["type"].stringValue == "1" {
                list.append(self.createTextNode(data: data))
            } else if data["type"].stringValue == "2" {
                list.append(self.createImageNode(data: data))
            }
        }
        return list
    }
    
    func createTextNode(data: JSON) -> ReaderContentElement {
        let textNode: ASTextNode = self.makeAndAddTextNode().then {
            $0.attributedText = data["text"].stringValue
                .withTextColor(Color.color3).withFont(Font.thin(size: 16))
                .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
        }
        if data["isNote"].stringValue == "1" {
            textNode.textContainerInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
            textNode.backgroundColor = UIColor.paraBgColor
        }
        return ReaderContentElement.init(type: .text, data: data, node: textNode)
    }
    
    func createImageNode(data: JSON) -> ReaderContentElement {
        let imageNode: ASNetworkImageNode = self.makeAndAddNetworkImageNode().then {
            $0.url = URL.init(string: data["sourceUrl"].stringValue)
            $0.defaultImage = UIImage.defaultImage
            $0.style.preferredSize = self.getImageSize(imageDataJSON: data)
        }
        return ReaderContentElement.init(type: .image, data: data, node: imageNode)
    }
    
    private func getImageSize(imageDataJSON: JSON) -> CGSize {
        let imageWidth: CGFloat = imageDataJSON["imageWidth"].floatValue.cgFloat
        let imageHeight: CGFloat = imageDataJSON["imageHeight"].floatValue.cgFloat
        if imageWidth == 0 || imageHeight == 0 {
            return CGSize.init(width: 0, height: 0)
        }
        let viewWidth: CGFloat = UIScreen.main.bounds.width - self.contentInset.left - self.contentInset.right
        let viewHeight: CGFloat = viewWidth * (imageHeight / imageWidth)
        return CGSize.init(width: viewWidth, height: viewHeight)
    }
    
    func buildLayoutSpec() -> ASLayoutSpec {
        
        let titleSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(20, 20, 0, 20), child: self.titleTextNode)
        
        var authorSpec: ASLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: 5,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.center,
                                                children: [self.authorAvatarImageNode, self.authorTextNode])
        
        authorSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0),
                                            child: authorSpec)
        
        var authorInfoBarSpec: ASLayoutSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                       spacing: 0,
                                                       justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                                       alignItems: ASStackLayoutAlignItems.center,
                                                       children: [authorSpec, self.attendButtonNode])
        authorInfoBarSpec = makeInsetSpec(spec: authorInfoBarSpec)
        
        
        var contentlist: [ASLayoutElement] = []
        self.paragraphContentlist.forEach { (element) in
            contentlist.append(self.makeInsetSpec(spec: element.node))
        }
        
        var children: [ASLayoutElement] = [titleSpec, authorInfoBarSpec] + contentlist
        children.append(ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(0, 20, 20, 20), child: self.feedbackTextNode))
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 10,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: children)
        
        return mainSpec
    }
    
    func makeInsetSpec(spec: ASLayoutElement) -> ASLayoutSpec {
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20),
                                      child: spec)
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

fileprivate class EditMenu: UIView {
    
    var deleteButton: UIButton?
    
    var noteButton: UIButton?
    
    var shareButton: UIButton?
    
    var copyButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        
        backgroundColor = UIColor.white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize.init(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.cornerRadius = 1
        
        let btn1 = self.makeButton(image: UIImage.init(named: "more"),showLine: true, title: "笔记管理").then {
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.width.equalTo(self.snp.width).multipliedBy(0.25)
            })
        }
        self.deleteButton = btn1
        
        let btn2 = self.makeButton(image: UIImage.init(named: "editmenu_notes"), showLine: true, title: "添加笔记").then {
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(self.snp.width).multipliedBy(0.25)
                make.left.equalTo(btn1.snp.right)
            })
        }
        self.noteButton = btn2
        
        let btn3 = self.makeButton(image: UIImage.init(named: "editmenu_share"), showLine: true, title: "分享").then {
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(self.snp.width).multipliedBy(0.25)
                make.left.equalTo(btn2.snp.right)
            })
        }
        self.shareButton = btn3
        
        self.copyButton = self.makeButton(image: UIImage.init(named: "editmenu_copy"), showLine: false, title: "复制").then {
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(self.snp.width).multipliedBy(0.25)
                make.left.equalTo(btn3.snp.right)
            })
        }
        
        CAShapeLayer.init().do { (layer) in
            let frame = CGRect.init(x: self.frame.width/2, y: self.frame.height, width: 18, height: 14)
            layer.frame = frame
            self.layer.addSublayer(layer)
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint.init(x: 0, y: 0))
            path.addLine(to: CGPoint.init(x: frame.width / 2, y: frame.height))
            path.addLine(to: CGPoint.init(x: frame.width, y: 0))
            path.addLine(to: CGPoint.init(x: 0, y: 0))
            
            layer.fillColor = UIColor.white.cgColor
            layer.strokeColor = UIColor.white.cgColor
            
            layer.path = path.cgPath
            path.fill()
        }
        
    }
    
    @discardableResult
    func makeButton(image: UIImage?, showLine: Bool, title: String) -> UIButton {
        return UIButton.init(type: .custom).then {
            let image = UIImageView.init(image: image)
            image.contentMode = .scaleAspectFit
            $0.addSubview(image)
            let btn = $0
            image.snp.makeConstraints({ (make) in
                make.centerX.equalTo(btn.snp.centerX)
                make.top.equalTo(10)
                make.width.height.equalTo(16)
            })
            
            UILabel().do({ (label) in
                btn.addSubview(label)
                label.font = UIFont.sys(size: 10)
                label.textColor = UIColor.color9
                label.text = title
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(image.snp.bottom).offset(7)
                    make.centerX.equalTo(image.snp.centerX)
                })
            })
            
            if showLine {
                let vLine = UIView.init()
                vLine.backgroundColor = UIColor.hexColor(hex: "e9e9e9")
                $0.addSubview(vLine)
                vLine.snp.makeConstraints({ (make) in
                    make.right.equalTo(0)
                    make.top.equalTo(15)
                    make.bottom.equalTo(-15)
                    make.width.equalTo(1)
                })
            }
        }
    }
    
}
