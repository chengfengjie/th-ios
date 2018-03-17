//
//  ArticleDetailViewLyout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol ArticleDetailViewLayout: ReaderLayout {
    
}

class ArticleContentCellNode: ReaderContentCellNode {
    
    var followAction: Action<(), JSON, RequestError>?
    
    var cancelFollowAction: Action<(), JSON, RequestError>?
    
    var authorAction: Action<(), AuthorViewModel, NoError>?
    
    var feedbackAction: Action<(), FeedbackViewModel, NoError>?
    
    var isFollow: Bool = false
    
    override init(dataJSON: JSON) {
        super.init(dataJSON: dataJSON)
        
        self.attendButtonNode.addTarget(
            self, action: #selector(self.handleFollowAuthor),
            forControlEvents: .touchUpInside)
        
        self.isFollow = dataJSON["isfollow"].stringValue == "1"
        
        self.authorAvatarImageNode.addTarget(
            self, action: #selector(self.handleAuthor),
            forControlEvents: .touchUpInside)
        
        self.sourceContainer.addTarget(
            self, action: #selector(self.handleAuthor),
            forControlEvents: .touchUpInside)
        
        self.feedbackTextNode.addTarget(
            self, action: #selector(self.handleFeedback),
            forControlEvents: .touchUpInside)
        
        self.updateFollowState()
    }
    
    @objc func handleFollowAuthor() {
        if self.isFollow {
            self.cancelFollowAction?.apply(()).start()
            self.isFollow = false
        } else {
            self.followAction?.apply(()).start()
            self.isFollow = true
        }
        self.updateFollowState()
    }
    
    @objc func handleAuthor() {
        self.authorAction?.apply(()).start()
    }
    
    func updateFollowState() {
        if isFollow {
            self.attendButtonNode.setAttributedTitle("取消关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.color9), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.color9.cgColor
            self.attendButtonNode.borderWidth = 1
        } else {
            self.attendButtonNode.setAttributedTitle("+ 关注"
                .withFont(Font.sys(size: 13))
                .withTextColor(Color.pink), for: UIControlState.normal)
            self.attendButtonNode.borderColor = UIColor.pink.cgColor
            self.attendButtonNode.borderWidth = 1
        }
    }
    
    @objc func handleFeedback() {
        self.feedbackAction?.apply(()).start()
    }
    
    override func clickMenuEdit() {
        if let element = self.currentContentElement {
            let model = AddEditNoteViewModel(paraContent: element.data)
            self.rootPresent(viewController: AddEditNoteViewController(viewModel: model), animated: true)
        }
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

