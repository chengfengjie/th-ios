//
//  ArticleCommentViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleCommentListViewModel: BaseViewModel, ArticleClient {

    var commentlist: MutableProperty<[JSON]>!
    
    var fetchCommentlistAction: Action<(), [JSON], HttpError>!
    
    var replayCommentAction: Action<JSON, CommentArticleViewModel, NoError>!
    
    var likeCommentAction: Action<JSON, JSON, HttpError>!
    
    var commentTotal: MutableProperty<Int>!
    
    let articleID: String
    init(articleID: String) {
        self.articleID = articleID
        super.init()
        
        self.commentlist = MutableProperty<[JSON]>([])
        
        self.commentTotal = MutableProperty(0)
        
        self.fetchCommentlistAction = Action<(), [JSON], HttpError>
            .init(execute: { (arg0) -> SignalProducer<[JSON], HttpError> in
                return self.createFetchCommentlistSignalProducer()
        })
        
        self.replayCommentAction = Action<JSON, CommentArticleViewModel, NoError>
            .init(execute: { (comment) -> SignalProducer<CommentArticleViewModel, NoError> in
                if self.currentUser.isLogin.value {
                    let model = CommentArticleViewModel(articleID: articleID)
                    model.isReply = true
                    model.commentId = comment["commentId"].stringValue
                    model.replyUser = comment["userName"].stringValue
                    model.commentAction.values.observeValues({ (data) in
                        self.fetchCommentlistAction.apply(()).start()
                    })
                    return SignalProducer.init(value: model)
                } else {
                    self.requestError.value = RequestError.forbidden
                    return SignalProducer.empty
                }
        })
        
        self.likeCommentAction = Action<JSON, JSON, HttpError>
            .init(execute: { (comment) -> SignalProducer<JSON, HttpError> in
                if self.currentUser.isLogin.value {
                    return self.createLikeCommmentSignalProducer(comment: comment)
                } else {
                    self.httpError.value = HttpError.forbidden
                    return SignalProducer.empty
                }
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchCommentlistAction.apply(()).start()
    }
    
    private func createFetchCommentlistSignalProducer() -> SignalProducer<[JSON], HttpError> {
        let (signal, observer) = Signal<[JSON], HttpError>.pipe()
        self.getArticleCommentList(articleId: self.articleID, pageNum: 1).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
                self.commentlist.value = data["list"].arrayValue
                observer.send(value: self.commentlist.value)
                observer.sendCompleted()
            case let .failure(error):
                self.httpError.value = error
                observer.send(error: error)
            }
        }
        
        return SignalProducer.init(signal)
    }
    
    private func createLikeCommmentSignalProducer(comment: JSON) -> SignalProducer<JSON, HttpError> {
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.isRequest.value = true
        if comment["isLike"].boolValue {
            self.cancelLikeArticleComment(commentId: comment["commentId"].stringValue, userId: UserModel.current.userID.value).observeResult { (result) in
                switch result {
                case let .success(data):
                    print(data)
                    var commentDict = comment.dictionaryValue
                    commentDict["isLike"] = false
                    commentDict["likeTotal"] = JSON.init(comment["likeTotal"].intValue - 1)
                    observer.send(value: JSON.init(commentDict))
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                    observer.send(error: error)
                }
            }
        } else {
            self.likeArticleComment(commentId: comment["commentId"].stringValue, userId: UserModel.current.userID.value).observeResult { (result) in
                switch result {
                case let .success(data):
                    print(data)
                    var commentDict = comment.dictionaryValue
                    commentDict["isLike"] = true
                    commentDict["likeTotal"] = JSON.init(comment["likeTotal"].intValue + 1)
                    observer.send(value: JSON.init(commentDict))
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                    observer.send(error: error)
                }
            }
        }
        return SignalProducer.init(signal)
    }
}
