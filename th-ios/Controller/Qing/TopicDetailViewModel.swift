//
//  TopicDetailViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/24.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TopicDetailViewModel: BaseViewModel, QingApi, CommonApi {

    var fetchTopicDetailAction: Action<(), JSON, RequestError>!
    
    var topicData: MutableProperty<JSON>!
    
    var fetchTopicAdAction: Action<(), JSON, RequestError>!
    
    var adData: MutableProperty<JSON>!
    
    let topicID: String
    init(topicID: String) {
        self.topicID = topicID
        super.init()
        
        self.topicData = MutableProperty<JSON>(JSON.empty)
        
        self.adData = MutableProperty<JSON>(JSON.empty)
        
        self.fetchTopicDetailAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchTopicInfoSignalProducer()
        })
        
        self.fetchTopicAdAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchTopicAdSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        fetchTopicDetailAction.apply(()).start()
        
        fetchTopicAdAction.apply(()).start()
    }
    
    private func createFetchTopicInfoSignalProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestQingTopicInfo(tid: self.topicID).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.topicData.value = value["data"]
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                print(error)
                self.requestError.value = error
                observer.send(error: error)
            }
            self.isRequest.value = false
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
    
}
