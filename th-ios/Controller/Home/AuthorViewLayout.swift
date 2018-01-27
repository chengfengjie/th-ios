//
//  AuthorViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol AuthorViewLayout {
    var changeHeader: AuthorChnageHeader { get }
}
extension AuthorViewLayout {
    func makeChangeHeader() -> AuthorChnageHeader {
        return AuthorChnageHeader()
    }
}

class AuthorTopBasicInfo: ASCellNode, CellNodeElementLayout {
    
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var authorNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var articleTotalTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var descriptionTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var attentionButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 80, height: 80)
        
        self.avatarImageNode.url = URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")
        
        self.authorNameTextNode.attributedText = "孕妇小助理".withFont(Font.systemFont(ofSize: 20))
        
        self.articleTotalTextNode.attributedText = "29122 篇文章".withFont(Font.systemFont(ofSize: 12)).withTextColor(Color.color9)
        
        self.descriptionTextNode.attributedText = "学校被查封、玉芬的离去、以及女儿马小翠的自杀未遂，一连串的打击让马大帅难以承受，急火攻心使马大帅突然双目失明。玉芬的表妹李萍一直在照顾着失明的马大帅。而在马大帅的内心深处，仍对玉芬怀有至深的情感。马大帅虽然双目失明，但感觉心里清静了许多，同意让马小翠与吴总离婚。小翠与钢子有情人终成眷属。同时，马大帅学习了盲人按摩技术，准备带领乡亲们开办一家盲人按摩诊所……".withTextColor(Color.color6).withFont(Font.systemFont(ofSize: 11))
        
        self.attentionButtonNode.setAttributedTitle("+ 关注".withTextColor(Color.white), for: UIControlState.normal)
        
        self.attentionButtonNode.backgroundColor = UIColor.pink
        
        self.attentionButtonNode.style.preferredSize = CGSize.init(width: UIScreen.main.bounds.width - 30, height: 40)
        
        self.attentionButtonNode.cornerRadius = 3
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let authorInfoSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                                    spacing: 20,
                                                    justifyContent: ASStackLayoutJustifyContent.start,
                                                    alignItems: ASStackLayoutAlignItems.stretch,
                                                    children: [self.authorNameTextNode, self.articleTotalTextNode])
        let topSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: 15,
                                             justifyContent: ASStackLayoutJustifyContent.start,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [self.avatarImageNode, authorInfoSpec])
        
        let attentionSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                   spacing: 0,
                                                   justifyContent: ASStackLayoutJustifyContent.center,
                                                   alignItems: ASStackLayoutAlignItems.center,
                                                   children: [self.attentionButtonNode])
        
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 15,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [topSpec, self.descriptionTextNode, attentionSpec])
        
        let mainInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15), child: mainSpec)
        return mainInset
    }
    
}

class AttentionAuthorCellNode: ASCellNode, CellNodeElementLayout {
    var avatarUrls: [URL] = []
    lazy var textNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var indicator: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    var avatarImageNodeArray: [ASNetworkImageNode] = []
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.avatarUrls = [
            URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")!,
            URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")!]
        
        self.avatarImageNodeArray.append(ASNetworkImageNode().then {
            $0.url = self.avatarUrls[0]
            self.addSubnode($0)
            $0.style.preferredSize = CGSize.init(width: 40, height: 40)
            $0.cornerRadius = 20
        })
        
        self.textNode.attributedText = "等1233人关注TA".withTextColor(Color.color9).withFont(Font.systemFont(ofSize: 9))
        self.indicator.image = UIImage.init(named: "home_right_indicator")
        self.indicator.style.preferredSize = CGSize.init(width: 20, height: 20)
    
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let rightSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                               spacing: 10,
                                               justifyContent: ASStackLayoutJustifyContent.start,
                                               alignItems: ASStackLayoutAlignItems.center,
                                               children: [self.textNode, self.indicator])
        let leftSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 5,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children:self.avatarImageNodeArray)
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [leftSpec, rightSpec])
        let insetSpec = ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(20, 15, 20, 15), child: mainSpec)
        return insetSpec
    }
}

class AuthorChnageHeader: BaseView {
    
    let headerBounds: CGRect = CGRect.init(
        x: 0, y: 0, width: UIScreen.main.bounds.height, height: 50)
    
    private var items: [UIButton] = []
    
    private let line: UIView = UIView()

    override func setupSubViews() {
        
        self.backgroundColor = UIColor.hexColor(hex: "f9f9f9")
        
        let newest: UIButton = UIButton().then {
            self.addSubview($0)
            $0.setTitle("最新记录", for: UIControlState.normal)
            $0.setTitleColor(UIColor.color6, for: UIControlState.normal)
            $0.setTitleColor(UIColor.pink, for: UIControlState.selected)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.bottom.equalTo(0)
            })
            $0.isSelected = true
        }
        
        let comment: UIButton = UIButton.init(type: .custom).then {
            self.addSubview($0)
            $0.setTitle("最新评论", for: UIControlState.normal)
            $0.setTitleColor(UIColor.color6, for: UIControlState.normal)
            $0.setTitleColor(UIColor.pink, for: UIControlState.selected)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(newest.snp.right).offset(30)
                make.top.bottom.equalTo(0)
            })
        }
        
        
        let hot: UIButton = UIButton.init(type: .custom).then {
            self.addSubview($0)
            $0.setTitle("热门", for: UIControlState.normal)
            $0.setTitleColor(UIColor.color6, for: UIControlState.normal)
            $0.setTitleColor(UIColor.pink, for: UIControlState.selected)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(comment.snp.right).offset(30)
                make.top.bottom.equalTo(0)
            })
        }
        
        self.items = [newest, comment, hot]
        
        line.do {
            $0.backgroundColor = UIColor.pink
            self.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(newest.snp.centerX)
                make.bottom.equalTo(-5)
                make.height.equalTo(2)
                make.width.equalTo(50)
            })
        }
        
        self.items.forEach {
            $0.addTarget(self, action: #selector(self.handleClickItem(sender:)),
                         for: UIControlEvents.touchUpInside)
        }
    }
    
    @objc func handleClickItem(sender: UIButton) {
        self.items.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
        
        self.line.snp.remakeConstraints { (make) in
            make.centerX.equalTo(sender.snp.centerX)
            make.bottom.equalTo(-5)
            make.height.equalTo(2)
            make.width.equalTo(50)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
}

class AuthorArticleListCellNode: ASCellNode, NoneContentArticleCellNode {
    
    lazy var categoryTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var imageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var sourceIconImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var sourceTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var unlikeButtonNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    override init() {
        super.init()
        
        self.selectionStyle = .none
        
        self.sourceIconImageNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        
        self.categoryTextNode.setText(text: "小学教育", style: self.layoutCss.cateNameTextStyle)
        self.titleTextNode.setText(text: "赵薇和他背后的隐秘富豪赵薇和他背后的隐秘富豪赵薇和他背后的隐秘富豪", style: self.layoutCss.titleTextStyle)
        self.imageNode.url = URL.init(string: "http://a.hiphotos.baidu.com/image/h%3D300/sign=c17af2b3bb51f819ee25054aeab54a76/d6ca7bcb0a46f21f46612acbfd246b600d33aed5.jpg")
        self.imageNode.style.preferredSize = self.layoutCss.imageSize
        
        self.sourceIconImageNode.url = URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")
        self.sourceTextNode.style.preferredSize = self.layoutCss.sourceIconSize
        
        self.sourceTextNode.setText(text: "21世纪", style: self.layoutCss.sourceNameTextStyle)
        
        self.unlikeButtonNode.setTitleText(text: "不喜欢", style: self.layoutCss.sourceNameTextStyle)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
    }
    
    var layoutCss: NoneContentArticleCellNodeStyle {
        return self.css.home_nocontent_article_cell_node
    }
}
















