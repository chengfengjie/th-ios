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

class AuthorTopBasicInfo: ASCellNode, NodeElementMaker, NodeBottomlineMaker {
    
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
    
    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomlineNode()
    }()
    
    init(dataJSON: JSON) {
        super.init()
        
        self.selectionStyle = .none
        
        self.bottomline.backgroundColor = UIColor.lineColor
        
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 80, height: 80)
        
        self.avatarImageNode.url = URL.init(string: dataJSON["aImg"].stringValue)
        self.avatarImageNode.defaultImage = UIImage.defaultImage
        
        self.authorNameTextNode.attributedText = dataJSON["aAuthor"].stringValue
            .withFont(Font.systemFont(ofSize: 20))
        
        self.articleTotalTextNode.attributedText = "\(dataJSON["aArticlenum"].stringValue) 篇文章"
            .withFont(Font.systemFont(ofSize: 12))
            .withTextColor(Color.color9)
        
        self.descriptionTextNode.attributedText = dataJSON["aSummary"].stringValue
            .withTextColor(Color.color6)
            .withFont(Font.systemFont(ofSize: 11))
        
        if dataJSON["follow"].stringValue == "0" {
            self.attentionButtonNode.setAttributedTitle("+ 关注"
                .withTextColor(Color.white), for: UIControlState.normal)
            self.attentionButtonNode.backgroundColor = UIColor.pink
        } else {
            self.attentionButtonNode.setAttributedTitle("取消关注"
                .withTextColor(Color.white), for: UIControlState.normal)
            self.attentionButtonNode.backgroundColor = UIColor.lightGray
        }
        
        
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
        
        let mainInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 15, left: 15, bottom: 20, right: 15), child: mainSpec)
        return self.makeBottomlineWraperSpec(mainSpec: mainInset,
                                             lineInset: UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15))
    }
    
}

class AttentionAuthorCellNode: ASCellNode, NodeElementMaker, NodeBottomlineMaker {
    
    lazy var bottomline: ASDisplayNode = {
        return self.makeBottomlineNode()
    }()
    
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
        
        self.bottomline.backgroundColor = UIColor.lineColor
        
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
        return self.makeBottomlineWraperSpec(mainSpec: insetSpec)
    }
}

class AuthorChnageHeader: BaseView {
    
    var clickAction: Action<(AuthorArticleType), [JSON], RequestError>?
    
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
            $0.tag = 100
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
            $0.tag = 101
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
            $0.tag = 102
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
        
        UIView().do { (l) in
            self.addSubview(l)
            l.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(CGFloat.pix1)
            })
            l.backgroundColor = UIColor.lineColor
            
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
        
        switch sender.tag {
        case 100:
            self.clickAction?.apply((AuthorArticleType.news)).start()
        case 101:
            self.clickAction?.apply((AuthorArticleType.comment)).start()
        case 102:
            self.clickAction?.apply((AuthorArticleType.hot)).start()
        default:
            break
        }
    }
    
}

class AuthorArticleListCellNode: NoneContentArticleCellNodeImpl {
    
    init(dataJSON: JSON) {
        super.init()
        
        self.titleTextNode.setText(text: dataJSON["title"].stringValue, style: self.layoutCss.titleTextStyle)
        self.imageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.sourceIconImageNode.url = URL.init(string: dataJSON["pic"].stringValue)
        self.sourceTextNode.setText(text: dataJSON["author"].stringValue, style: self.layoutCss.sourceNameTextStyle)

    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildImageLayoutSpec(constrainedSize: constrainedSize)
    }
    
}
















