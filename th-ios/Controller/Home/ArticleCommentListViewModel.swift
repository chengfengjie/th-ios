//
//  ArticleCommentViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ArticleCommentListViewModel: BaseViewModel, ArticleApi {

    var commentlist: MutableProperty<[JSON]>!
    
    var fetchCommentlistAction: Action<(), [JSON], RequestError>!
    
    var replayCommentAction: Action<JSON, CommentArticleViewModel, RequestError>!
    
    var likeCommentAction: Action<JSON, JSON, RequestError>!
    
    let articleID: String
    init(articleID: String) {
        self.articleID = articleID
        super.init()
        
        self.commentlist = MutableProperty<[JSON]>([])
        
        self.fetchCommentlistAction = Action<(), [JSON], RequestError>
            .init(execute: { (arg0) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchCommentlistSignalProducer()
        })
        
        self.replayCommentAction = Action<JSON, CommentArticleViewModel, RequestError>
            .init(execute: { (comment) -> SignalProducer<CommentArticleViewModel, RequestError> in
                if self.currentUser.isLogin.value {
                    let model = CommentArticleViewModel(articleID: articleID)
                    model.isReply = true
                    model.commentId = comment["cid"].stringValue
                    return SignalProducer.init(value: model)
                } else {
                    self.requestError.value = RequestError.forbidden
                    return SignalProducer.empty
                }
        })
        
        self.likeCommentAction = Action<JSON, JSON, RequestError>
            .init(execute: { (comment) -> SignalProducer<JSON, RequestError> in
                if self.currentUser.isLogin.value {
                    return self.createLikeCommmentSignalProducer(comment: comment)
                } else {
                    self.requestError.value = RequestError.forbidden
                    return SignalProducer.empty
                }
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchCommentlistAction.apply(()).start()
    }
    
    private func createFetchCommentlistSignalProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        
        requestArticleCommentlist(articleID: self.articleID).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
                let list = data["data"]["commentlist"].arrayValue
                self.commentlist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.requestError.value = error
            }
        }
        
        return SignalProducer.init(signal)
    }
    
    private func createLikeCommmentSignalProducer(comment: JSON) -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestLikeArticleComment(cid: comment["cid"].stringValue).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
}
