//
//  CommentTopicViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class CommentTopicViewModel: BaseViewModel, QingApi {
    
    var commentText: MutableProperty<String>!
    
    var enableComment: MutableProperty<Bool>!
    
    var commentAction: Action<(), JSON, RequestError>!

    var moduleID: String
    var topicID: String
    init(moduleID: String, pid: String) {
        self.moduleID = moduleID
        self.topicID = pid
        super.init()
        
        self.enableComment = MutableProperty<Bool>(false)
        
        self.commentText = MutableProperty<String>("")
        
        self.enableComment <~ Signal.combineLatest(self.isRequest.signal, self.commentText.signal)
            .map({ (tup) -> Bool in
                let (isReq, text) = tup
                return !isReq && !text.isEmpty
            })
        
        self.commentAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createCommentSignalProducer()
        })
    }
    
    private func createCommentSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestCommentTopic(moduleID: self.moduleID,
                            topicId: self.topicID,
                            message: self.commentText.value)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(value):
                    print(value)
                    self.okMessage.value = "评论成功"
                    observer.send(value: value)
                    observer.sendCompleted()
                case let .failure(error):
                    self.requestError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }
    
}
