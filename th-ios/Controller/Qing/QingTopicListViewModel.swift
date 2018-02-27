//
//  QingTopicListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

enum TopicListType: Int {
    case news = 100
    case published = 101
    case attented = 102
    case viewhistory = 103
        
    func getTitle() -> String {
        switch self {
        case .news:
            return "最新话题"
        case .published:
            return "我发表的话题"
        case .attented:
            return "我参与的话题"
        case .viewhistory:
            return "最近浏览"
        }
    }
    
    var requestTypeID: Int {
        switch self {
        case .news:
            return 0
        case .published:
            return 1
        case .attented:
            return 2
        case .viewhistory:
            return 3
        }
    }
}

class QingTopicListViewModel: BaseViewModel, QingApi {
    
    var page: MutableProperty<Int>!
    
    var topiclist: MutableProperty<[JSON]>!
    
    var fetchTopiclistAction: Action<Int, JSON, RequestError>!
    
    let type: TopicListType
    init(type: TopicListType) {
        self.type = type
        super.init()
        
        self.page = MutableProperty(1)
        
        self.topiclist = MutableProperty([])
        
        self.fetchTopiclistAction = Action<Int, JSON, RequestError>
            .init(execute: { (page) -> SignalProducer<JSON, RequestError> in
            return self.createFetchTopiclistSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchTopiclistAction.apply(1).start()
    }
    
    private func createFetchTopiclistSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestQingTopiclist(type: self.type.requestTypeID, page: self.page.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                self.topiclist.value = value["data"]["tlist"].arrayValue
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
