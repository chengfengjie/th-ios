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
                make.width.equalTo(CGFloat.pix1)
            })
            $0.backgroundColor = UIColor.lineColor
        }
    }
}

class AuthorListCellNode: ASCellNode, NodeElementMaker {
    
    var clickAddAction: Action<IndexPath, JSON, RequestError>?
    var clickCancelAction: Action<IndexPath, JSON, RequestError>?
    
    lazy var avatarImageNode: ASNetworkImageNode = {
        return self.makeAndAddNetworkImageNode()
    }()
    lazy var authorNameTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var subscriptionCountTextNode: ASTextNode = {
        return self.makeAndAddTextNode()
    }()
    lazy var addIconImageNode: ASButtonNode = {
        return self.makeAndAddButtonNode()
    }()
    
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
    
        self.selectionStyle = .none
        
        self.addIconImageNode.style.preferredSize = CGSize.init(width: 40, height: 40)
        self.avatarImageNode.style.preferredSize = CGSize.init(width: 50, height: 50)
        self.avatarImageNode.cornerRadius = 25
        self.avatarImageNode.url = URL.init(string: dataJSON["aimg"].stringValue)
        self.avatarImageNode.defaultImage = UIImage.defaultImage
        
        self.authorNameTextNode.attributedText = dataJSON["author"].stringValue
            .withFont(Font.systemFont(ofSize: 18))
            .withTextColor(Color.color3)
        
        self.subscriptionCountTextNode.attributedText = "\(dataJSON["follownum"].stringValue) 订阅"
            .withTextColor(Color.color9)
            .withFont(Font.systemFont(ofSize: 12))
        
        self.addIconImageNode.cornerRadius = 5
        if dataJSON["isfollow"].stringValue == "0" {
            self.addIconImageNode.setAttributedTitle("+"
                .withTextColor(Color.white)
                .withFont(UIFont.sys(size: 20)),for: UIControlState.normal)
            self.addIconImageNode.backgroundColor = UIColor.pink
            
        } else {
            self.addIconImageNode.setAttributedTitle("取消"
                .withTextColor(Color.white).withFont(Font.sys(size: 12)), for: UIControlState.normal)
            self.addIconImageNode.backgroundColor = UIColor.lightGray
        }
        
        self.addIconImageNode.addTarget(
            self, action: #selector(self.clickAddIcon),
            forControlEvents: .touchUpInside)
    }
    
    @objc func clickAddIcon() {
        if let indexPath = self.indexPath {
            if self.dataJSON["isfollow"].stringValue == "0" {
                self.clickAddAction?.apply(indexPath).start()
            } else {
                self.clickCancelAction?.apply(indexPath).start()
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.authorNameTextNode.style.maxWidth = ASDimension.init(unit: ASDimensionUnit.points,
                                                                  value: constrainedSize.max.width - 170)
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


