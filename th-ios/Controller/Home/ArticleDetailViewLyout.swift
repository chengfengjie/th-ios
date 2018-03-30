//
//  ArticleDetailViewLyout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import MBProgressHUD

protocol ArticleDetailViewLayout: ReaderLayout {
    
}

class ArticleContentCellNode: ReaderContentCellNode {

    var followAction: Action<(), JSON, RequestError>?
    
    var cancelFollowAction: Action<(), JSON, RequestError>?
    
    var authorAction: Action<(), AuthorViewModel, NoError>?
    
    var feedbackAction: Action<(), FeedbackViewModel, NoError>?
    
    var shareParaImageAction: Action<UIImage, UIImage, NoError>!
    
    var isFollow: Bool = false
    
    var articleID: String = ""
    
    var model: ArticleDetailViewModel? = nil
    
    override init(dataJSON: JSON) {
        super.init(dataJSON: dataJSON)
        
        self.shareParaImageAction = Action<UIImage, UIImage, NoError>
            .init(execute: { (image) -> SignalProducer<UIImage, NoError> in
            return SignalProducer.init(value: image)
        })
        
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
            if UserModel.current.isLogin.value {
                let model = AddEditNoteViewModel(paraContent: element.data, aid: self.articleID)
                self.rootPresent(viewController: AddEditNoteViewController(viewModel: model), animated: true)
                model.callBackSignal.observeValues({ (text) in
                    element.addOrUpdateNoteText(text: text)
                })
            } else {
                self.rootPresentLoginController()
            }
        }
    }
    
    override func clickMenuDelete() {
        if let element = self.currentContentElement {
            self.model?.deleteArticleNoteAction.apply(element.data["id"].stringValue).start()
            self.model?.deleteArticleNoteAction.values.observeValues({ [weak self] (data) in
                self?.deleteNoteSuccess(element: element)
            })
        }
    }
    
    override func clickMenuCopy() {
        if let element = self.currentContentElement {
            UIPasteboard.general.string = element.data["text"]["text"].stringValue
            self.model?.okMessage.value = "复制成功"
        }
        self.hideMenu()
    }
    
    override func editMenuDidShow() {
        if let element = self.currentContentElement {
            if element.data["markups"].stringValue == "0" {
                self.model?.addEmptyNoteAction.apply(element.data["id"].stringValue).start()
                self.model?.addEmptyNoteAction.values.observeValues({ (val) in
                    element.addEmptyNoteComplete()
                })
            }
        }
    }
    
    override func clickMenuShare() {
        if let element = self.currentContentElement {
            let view = ParaShareImageView.crete(articleInfo: self.dataJSON, paraInfo: element.data)
            self.model?.isRequest.value = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.model?.isRequest.value = false
                self.shareParaImageAction.apply(view.buildImage()!).start()
            })
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

