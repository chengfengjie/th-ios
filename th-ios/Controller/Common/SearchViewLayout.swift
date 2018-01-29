//
//  SearchViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol SearchViewControllerLayout {
    func handleClickCancelItem()
    var searchControl: SearchControl { get }
}
extension SearchViewControllerLayout where Self: SearchViewController {
    
    func makeNavBarRightCancelButton() {
        let barContent: UIView = self.customeNavBar.navBarContent
        UIButton.init(type: .custom).do {
            barContent.addSubview($0)
            $0.setTitle("取消", for: UIControlState.normal)
            $0.titleLabel?.font = UIFont.songTi(size: 15)
            $0.setTitleColor(UIColor.color3, for: UIControlState.normal)
            $0.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.right.equalTo(-15)
                make.width.equalTo(barContent.snp.height)
            })
            $0.addTarget(self, action: #selector(self.handleClickCancelItem), for: UIControlEvents.touchUpInside)
        }
    }
    
    func makeSearchControl() -> SearchControl {
        let barContent: UIView = self.customeNavBar.navBarContent
        return SearchControl().then {
            barContent.addSubview($0)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-80)
                make.centerY.equalTo(barContent.snp.centerY)
                make.height.equalTo(32)
            })
        }
    }
}

class SearchControl: BaseView {
    lazy var searchIcon: UIImageView = {
        return UIImageView().then {
            self.addSubview($0)
        }
    }()
    lazy var textField: UITextField = {
        return UITextField().then {
            self.addSubview($0)
        }
    }()
    
    override func setupSubViews() {
        
        self.layer.borderColor = UIColor.hexColor(hex: "e7e7e7").cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.hexColor(hex: "fafafa")
        
        self.searchIcon.image = UIImage.init(named: "search_gray")
        self.searchIcon.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(16)
        }
        
        self.textField.placeholder = "搜索"
        self.textField.font = UIFont.systemFont(ofSize: 14)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.bottom.equalTo(0)
            make.right.equalTo(-10)
        }
    }
}

class SearchResultCellNode: ASCellNode, SearchResultCellNodeLayout {
    
    lazy var cateNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var titleTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var sourceAvatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    
    lazy var sourceNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    lazy var viewCountIconImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    
    lazy var viewCountTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    
    override init() {
        super.init()
        
        self.cateNameTextNode.attributedText = "辣妈生活"
            .withTextColor(Color.pink)
            .withFont(Font.systemFont(ofSize: 11))
        
        self.titleTextNode.attributedText = "在南京的雪中,走到白头"
            .withFont(Font.systemFont(ofSize: 18))
            .withTextColor(Color.color3)
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3))
        
        self.sourceAvatarImageNode.cornerRadius = self.sourceAvatarSize.width / 2.0
        self.sourceAvatarImageNode.url = URL.init(string: "https://himg.bdimg.com/sys/portrait/item/38b8e69184e5bdb1e5b888e69db0e5a4ab87b1.jpg")
        
        self.sourceNameTextNode.attributedText = "初恋战线"
            .withFont(Font.systemFont(ofSize: 11))
            .withTextColor(Color.color3)
        
        self.viewCountIconImageNode.image = UIImage.init(named: "search_eye")
        
        self.viewCountTextNode.attributedText = "11112"
            .withFont(Font.systemFont(ofSize: 11))
            .withTextColor(Color.color3)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.buildLayoutSpec()
    }
}

protocol SearchResultCellNodeLayout: NodeElementMaker {
    var cateNameTextNode: ASTextNode { get }
    var titleTextNode: ASTextNode { get }
    var sourceAvatarImageNode: ASNetworkImageNode { get }
    var sourceNameTextNode: ASTextNode { get }
    var viewCountIconImageNode: ASImageNode { get }
    var viewCountTextNode: ASTextNode { get }
}
extension SearchResultCellNodeLayout where Self: ASDisplayNode {
    
    var sourceAvatarSize: CGSize {
        return CGSize.init(width: 18, height: 18)
    }
    
    func buildLayoutSpec() -> ASLayoutSpec {
        
        self.sourceAvatarImageNode.style.preferredSize = self.sourceAvatarSize
        self.viewCountIconImageNode.style.preferredSize = CGSize.init(width: 14, height: 14)
        
        let sourceSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                spacing: 5,
                                                justifyContent: ASStackLayoutJustifyContent.start,
                                                alignItems: ASStackLayoutAlignItems.center,
                                                children: [self.sourceAvatarImageNode, self.sourceNameTextNode])
        let viewCountSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                                   spacing: 5,
                                                   justifyContent: ASStackLayoutJustifyContent.start,
                                                   alignItems: ASStackLayoutAlignItems.center,
                                                   children: [self.viewCountIconImageNode, self.viewCountTextNode])
        let barSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                             spacing: 0,
                                             justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                             alignItems: ASStackLayoutAlignItems.center,
                                             children: [sourceSpec, viewCountSpec])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.cateNameTextNode, self.titleTextNode, barSpec])
        return ASInsetLayoutSpec.init(insets: self.makeDefaultContentInset(), child: mainSpec)
    }
}
