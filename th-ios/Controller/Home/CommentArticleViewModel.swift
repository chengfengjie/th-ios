//
//  CommentArticleViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class CommentArticleViewModel: BaseViewModel, ArticleApi {

    var commentText: MutableProperty<String>!
    
    var enableComment: MutableProperty<Bool>!
    
    var commentAction: Action<(), JSON, RequestError>!
    
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
        
        self.commentAction = Action<(), JSON, RequestError>.init(
            enabledIf: self.enableComment,
            execute: { (tulp) -> SignalProducer<JSON, RequestError> in
            return self.createCommentSingalProducer()
        })
    }
    
    private func createCommentSingalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestCommentArticle(articleID: self.articleID, commentText: self.commentText.value)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    self.successMsg.value = "评论成功"
                    observer.send(value: data["data"])
                    observer.sendCompleted()
                case let .failure(error):
                    observer.send(error: error)
                    self.errorMsg.value = error.localizedDescription
                }
        }
        return SignalProducer.init(signal)
    }
    
}
