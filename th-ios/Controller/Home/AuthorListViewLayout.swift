//
//  AuthorListViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

fileprivate class LayoutParam {
    
}

protocol AuthorListViewLayout {
    var menuTableNode: ASTableNode { get }
    var contentTableNode: ASTableNode { get }
}
extension AuthorListViewLayout where Self: AuthorListViewController {
    
    var menuTableNodeSize: CGSize {
        return CGSize.init(width: 90, height: self.window_height)
    }
    
    var menuTableNodeFrame: CGRect {
        return CGRect.init(origin: CGPoint.zero, size: self.menuTableNodeSize)
    }
    
    var contentTableNodeFrame: CGRect {
        let width: CGFloat = self.window_width - self.menuTableNodeSize.width
        return CGRect.init(origin: CGPoint.init(x: self.menuTableNodeSize.width, y: 0),
                           size: CGSize.init(width: width, height: self.window_height))
    }
    
    func makeMenuTableNode() -> ASTableNode {
        return ASTableNode.init(style: .grouped).then {
            $0.backgroundColor = UIColor.white
            self.content.addSubnode($0)
            $0.frame = self.menuTableNodeFrame
            $0.view.separatorStyle = .none
            $0.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
    }
    
    func makeContentTableNode() -> ASTableNode {
        return ASTableNode.init(style: .grouped).then {
            $0.backgroundColor = UIColor.white
            $0.frame = self.contentTableNodeFrame
            self.content.addSubnode($0)
            $0.view.separatorStyle = .none
        }
    }
    
    func makeTableNodeSepline() {
        UIView().do {
            self.content.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(self.menuTableNodeSize.width)
                make.width.equalTo(1)
            })
            $0.backgroundColor = UIColor.lineColor
        }
    }
}

class AuthorListCellNode: ASCellNode, CellNodeElementLayout {
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var authorNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var subscriptionCountTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var addIconImageNode: ASImageNode = {
        return self.makeAndAddImageNode()
    }()
    override init() {
        super.init()
    
        self.selectionStyle = .none
        
        self.addIconImageNode.style.preferredSize = CGSize.init(width: 30, height: 30)
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 50, height: 50)
        self.avatarImageNode.cornerRadius = 25
        self.avatarImageNode.url = URL.init(string: "http://c.hiphotos.baidu.com/image/h%3D300/sign=6d0bf83bda00baa1a52c41bb7711b9b1/0b55b319ebc4b745b19f82c1c4fc1e178b8215d9.jpg")
        
        self.authorNameTextNode.attributedText = "宝贝健康周".withFont(Font.systemFont(ofSize: 18)).withTextColor(Color.color3)
        self.subscriptionCountTextNode.attributedText = "281212 订阅".withTextColor(Color.color9).withFont(Font.systemFont(ofSize: 12))
        self.addIconImageNode.image = UIImage.init(named: "home_author_add")
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.vertical,
                                              spacing: 5,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.stretch,
                                              children: [self.authorNameTextNode, self.subscriptionCountTextNode])
        let leftSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 20,
                                              justifyContent: ASStackLayoutJustifyContent.start,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [self.avatarImageNode, nameSpec])
        let mainSpec = ASStackLayoutSpec.init(direction: ASStackLayoutDirection.horizontal,
                                              spacing: 0,
                                              justifyContent: ASStackLayoutJustifyContent.spaceBetween,
                                              alignItems: ASStackLayoutAlignItems.center,
                                              children: [leftSpec, self.addIconImageNode])
        let mainInset = ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(25, 25, 25, 25),
                                               child: mainSpec)
        return mainInset
    }
}


