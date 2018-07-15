//
//  CommentArticleViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift
import DateTools

class CommentArticleViewModel: BaseViewModel, ArticleClient {

    var commentText: MutableProperty<String>!
    
    var enableComment: MutableProperty<Bool>!
    
    var commentAction: Action<(), JSON, HttpError>!
    
    var isReply: Bool = false
    
    var commentId: String = ""
    
    var replyUser: String = ""
    
    let articleID: String
    init(articleID: String) {
        self.articleID = articleID
        super.init()

        self.commentText = MutableProperty("")
        
        self.enableComment = MutableProperty<Bool>(false)
        
        self.enableComment <~ Signal.combineLatest(self.isRequest.signal, self.commentText.signal)
            .map({ (tup) -> Bool in
            let (isReq, text) = tup
            return !isReq && !text.isEmpty
        })
        
        self.commentAction = Action<(), JSON, HttpError>.init(
            enabledIf: self.enableComment,
            execute: { (tulp) -> SignalProducer<JSON, HttpError> in
                if self.isReply {
                    return self.createReplyCommentSignalProducer()
                } else {
                    return self.createCommentSingalProducer()
                }
        })
    }
    
    private func createCommentSingalProducer() -> SignalProducer<JSON, HttpError> {
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.isRequest.value = true
        self.commentArticle(articleId: self.articleID, content: self.commentText.value, userId: UserModel.current.userID.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                self.okMessage.value = "评论成功"
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                self.httpError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createReplyCommentSignalProducer() -> SignalProducer<JSON, HttpError> {
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.replyComment(articleId: self.articleID, content: self.commentText.value, userId: UserModel.current.userID.value, commentId: self.commentId).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
                self.okMessage.value = "回复评论成功"
                let replyDict: [String: String] = [
                    "userId": UserModel.current.userID.value,
                    "content": self.commentText.value,
                    "inDate": Date().timeIntervalSince1970.description
                ]
                observer.send(value: JSON.init(replyDict))
                observer.sendCompleted()
            case let .failure(error):
                self.httpError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
}
