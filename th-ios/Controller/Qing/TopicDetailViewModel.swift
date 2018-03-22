//
//  TopicDetailViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/24.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TopicDetailViewModel: BaseViewModel, QingApi, CommonApi, UserApi {

    var fetchTopicDetailAction: Action<(), JSON, RequestError>!
    
    var topicData: MutableProperty<JSON>!
    
    var topicCommentlist: MutableProperty<[JSON]>!
    
    var fetchTopicAdAction: Action<(), JSON, RequestError>!
    
    var adData: MutableProperty<JSON>!
    
    var commentTopicAction: Action<(), CommentTopicViewModel, NoError>!
    
    var followUserAction: Action<(), JSON, RequestError>!
    
    var isflollow: MutableProperty<Bool>!
    
    let topicID: String
    init(topicID: String) {
        self.topicID = topicID
        super.init()
        
        self.topicData = MutableProperty<JSON>(JSON.empty)
        
        self.adData = MutableProperty<JSON>(JSON.empty)
        
        self.topicCommentlist = MutableProperty<[JSON]>([])
        
        self.isflollow = MutableProperty(false)
        
        self.fetchTopicDetailAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchTopicInfoSignalProducer()
        })
        
        self.fetchTopicAdAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchTopicAdSignalProducer()
        })
        
        self.commentTopicAction = Action<(), CommentTopicViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<CommentTopicViewModel, NoError> in
                if self.currentUser.isLogin.value {
                    let model = CommentTopicViewModel(moduleID: self.topicData.value["fid"].stringValue, pid: topicID);
                    return SignalProducer.init(value: model)
                } else {
                    self.requestError.value = RequestError.forbidden
                    return SignalProducer.empty
                }
        })
        
        self.followUserAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                if self.currentUser.isLogin.value {
                    self.isflollow.value = !self.isflollow.value
                    if self.isflollow.value {
                        return self.createFllowUserSignalProducer()
                    } else {
                        return self.createCancelFollowUserSignalProducer()
                    }
                } else {
                    self.requestError.value = RequestError.forbidden
                    return SignalProducer.empty
                }
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchTopicDetailAction.values.observeValues { (_) in
            self.fetchTopicAdAction.apply(()).start()
        }
    }
    
    private func createFetchTopicInfoSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestQingTopicInfo(tid: self.topicID).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                self.topicData.value = value["data"]
                self.topicCommentlist.value = value["data"]["posts"].arrayValue
                self.isflollow.value = value["data"]["isfollow"].stringValue == "1"
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchTopicAdSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestTopicAd(topicID: self.topicID).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                let list = value["data"]["advlist"]
                self.adData.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFllowUserSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestFllowUser(userID: self.topicData.value["authorid"].stringValue).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                observer.send(value: value)
                observer.sendCompleted()
                self.okMessage.value = "关注成功"
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createCancelFollowUserSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestCancelFollowUser(userId: self.topicData.value["authorid"].stringValue).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                self.okMessage.value = "取消关注成功"
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
