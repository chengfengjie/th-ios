//
//  ArticleCommentViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class ArticleCommentListHeaderElement {
    var container: UIView!
    var label: UILabel!
}

protocol ArticleCommentListViewLayout {
    
    var mainView: UIView { get }
    
    var tableNode: ASTableNode { get }
    
    var tableHeader: ArticleCommentListHeaderElement { get }
    
}
extension ArticleCommentListViewLayout where Self: ArticleCommentListViewController {
    
    private var mainOffsetY: CGFloat {
        return 90
    }
    
    private var mainHeight: CGFloat {
        return self.view.frame.height - self.mainOffsetY
    }
    
    private var animateBeginFrame: CGRect {
        return CGRect.init(origin: CGPoint.init(x: 0, y: self.view.frame.height),
                           size: CGSize.init(width: self.view.frame.width, height: self.mainHeight))
    }
    
    private var animateFinishFrame: CGRect {
        return CGRect.init(x: 0, y: self.mainOffsetY,
                           width: self.view.frame.width,
                           height: self.mainHeight)
    }
    
    func showMainView() {
        self.mainView.backgroundColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.animate(withDuration: 0.3) {
                self.mainView.frame = self.animateFinishFrame
            }
        }
    }
    
    func createMainView() -> UIView {
        return UIView.init().then {
            self.view.addSubview($0)
            $0.frame = self.animateBeginFrame
            $0.backgroundColor = UIColor.white
        }
    }
    
    func createLayoutTableNode() -> ASTableNode {
        return ASTableNode.init(style: UITableViewStyle.plain).then {
            self.mainView.addSubnode($0)
            $0.frame = self.mainView.bounds
            $0.view.tableHeaderView = self.tableHeader.container
            $0.view.separatorStyle = .none
        }
    }
    
    func createTableHeader() -> ArticleCommentListHeaderElement {
        
        let header: UIView = UIView().then {
            $0.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 55.5)
        }
        
        let label: UILabel = UILabel().then {
            header.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.top.bottom.equalTo(0)
            })
            $0.textColor = UIColor.color3
            $0.font = UIFont.sys(size: 17)
            $0.textAlignment = .center
            $0.text = "3条评论"
        }
        
        UIView().do {
            header.addSubview($0)
            $0.backgroundColor = UIColor.lineColor
            $0.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(CGFloat.pix1)
            })
        }
        
        let element = ArticleCommentListHeaderElement()
        element.container = header
        element.label = label
        return element
    }
    
}

class ArticleCommentListCellNode: CommentCellNode {
    
    var replayAction: Action<JSON, CommentArticleViewModel, NoError>?
    
    var likeAction: Action<JSON, JSON, HttpError>? {
        didSet {
            if likeAction != nil {
                likeAction?.values.observeValues({ (data) in
                    if self.dataJSON["commentId"].stringValue == data["commentId"].stringValue {
                        self.dataJSON = data
                        self.updateStatus()
                    }
                })
            }
        }
    }
    
    var dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.avatar.url = URL.init(string: dataJSON["userAvatar"].stringValue)
        
        let name: String = dataJSON["userName"].stringValue.isEmpty ? "暂无昵称" : dataJSON["userName"].stringValue
        self.nameTextNode.attributedText = name
            .withFont(Font.sys(size: 14))
            .withTextColor(Color.pink)
        
        self.dateTimeTextNode.attributedText = dataJSON["inDate"].stringValue
            .dateFormat()
            .withTextColor(Color.color9)
            .withFont(Font.sys(size: 10))
        
        self.updateStatus()
        
        self.commentTextNode.attributedText = dataJSON["content"].stringValue
            .withTextColor(Color.color3).withFont(Font.sys(size: 14))
            .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: NSTextAlignment.justified))
        
        self.replyButtonNode.addTarget(self, action: #selector(self.handleReply), forControlEvents: .touchUpInside)
        
        self.goodButtonNode.addTarget(self, action: #selector(self.handleLike), forControlEvents: .touchUpInside)

        self.goodTotalTextNode.addTarget(self, action: #selector(self.handleLike), forControlEvents: .touchUpInside)
        
        self.reportButtonNode.isHidden = true
        
        let children: [JSON] = dataJSON["children"].arrayValue;
        
        children.forEach { (data) in
            let replyNode: CommentReplyNode = CommentReplyNode()
            
            replyNode.line = ASDisplayNode().then({ (node) in
                node.backgroundColor = UIColor.hexColor(hex: "eeeeee")
                node.style.width = ASDimension.init(unit: ASDimensionUnit.points, value: 3)
                self.addSubnode(node)
            })
            
            
            replyNode.nickName = ASTextNode().then({ (node) in
                node.attributedText = data["userName"].stringValue.withFont(Font.sys(size: 10)).withTextColor(Color.pink)
                self.addSubnode(node)
            })
            
            replyNode.datetime = ASTextNode().then({ (node) in
                node.attributedText = data["inDate"].stringValue.dateFormat().withTextColor(Color.color9).withFont(Font.sys(size: 10))
                self.addSubnode(node)
            })
            
            replyNode.content = ASTextNode().then({ (node) in
                node.attributedText = data["content"].stringValue.withTextColor(Color.color6)
                    .withFont(Font.sys(size: 12))
                    .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: NSTextAlignment.justified))
                node.style.maxWidth = ASDimension.init(unit: ASDimensionUnit.points, value: UIScreen.main.bounds.width - 110)
                self.addSubnode(node)
            })
            
            replyNodes.append(replyNode)
        }
    }
    
    private func updateStatus() {
        if dataJSON["isLike"].boolValue {
            self.goodButtonNode.image = UIImage.init(named: "qing_like_color")
        } else {
            self.goodButtonNode.image = UIImage.init(named: "qing_like_dark_gray")
        }
        
        self.goodTotalTextNode.attributedText = dataJSON["likeTotal"].stringValue
            .withFont(.sys(size: 10))
            .withTextColor(Color.color9)
    }
    
    @objc func handleReply() {
        self.replayAction?.apply(self.dataJSON).start()
    }
    
    @objc func handleLike() {
        self.likeAction?.apply(self.dataJSON).start()
    }
    
}
