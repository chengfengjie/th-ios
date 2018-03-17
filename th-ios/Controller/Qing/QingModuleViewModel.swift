//
//  QingModuleViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingModuleViewModel: BaseViewModel, QingApi {
    
    var currentCateID: MutableProperty<String>!
    
    var fetchModuleDataAction: Action<(), JSON, RequestError>!
    
    var moduleData: MutableProperty<JSON>!
    
    var moduleToplist: MutableProperty<[JSON]>!
    
    var currentType: QingModuleTopiclistType = .news
    
    var fetchCatelistAction: Action<(), JSON, RequestError>!
    
    var catelist: MutableProperty<[JSON]>!
    
    var cateTitlelist: MutableProperty<[String]>!
    
    var fetchTopiclistAction: Action<(), [JSON], RequestError>!
    
    var topiclist: MutableProperty<[JSON]>!
    
    var topicDetailAction: Action<JSON, TopicDetailViewModel, NoError>!
    
    var publishTopicAction: Action<(), PublishTopicViewModel, RequestError>!
    
    let fid: String
    init(fid: String) {
        self.fid = fid
        super.init()
        
        self.moduleData = MutableProperty<JSON>(JSON.empty)
        self.moduleToplist = MutableProperty<[JSON]>([])
        
        self.catelist = MutableProperty<[JSON]>([])
        self.cateTitlelist = MutableProperty<[String]>([])
        
        self.currentCateID = MutableProperty<String>("")
        
        self.topiclist = MutableProperty<[JSON]>([])
        
        self.fetchTopiclistAction = Action<(), [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchTopiclistSignalProducer()
        })
        
        self.fetchModuleDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchModuleDataSignalProducer()
        })
        
        self.fetchCatelistAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchCatelistSignalProducer()
        })
        
        self.topicDetailAction = Action<JSON, TopicDetailViewModel, NoError>
            .init(execute: { (data) -> SignalProducer<TopicDetailViewModel, NoError> in
                return SignalProducer.init(value: TopicDetailViewModel(topicID: data["tid"].stringValue))
        })
        
        self.publishTopicAction = Action<(), PublishTopicViewModel, RequestError>
            .init(execute: { (_) -> SignalProducer<PublishTopicViewModel, RequestError> in
                if self.catelist.value.isEmpty {
                    return SignalProducer.init(error: RequestError.warning(message: "分类为空"))
                }
                if self.currentUser.isLogin.value {
                    return SignalProducer.init(value: PublishTopicViewModel(fid: self.fid, catelist: self.catelist.value))
                } else {
                    self.requestError.value = RequestError.forbidden
                    return SignalProducer.empty
                }
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchModuleDataAction.apply(()).start()
        
        self.fetchCatelistAction.apply(()).start()
        
        self.currentCateID.signal.observeValues { (_) in
            self.fetchTopiclistAction.apply(()).start()
        }
    }
    
    private func createFetchModuleDataSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        self.requestQingModuleData(fid: self.fid).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                self.moduleData.value = value["data"]
                self.moduleToplist.value = value["data"]["toplist"].arrayValue
                observer.send(value: value["data"])
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchCatelistSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestQingModuleCatelist(fid: self.fid).observeResult { (result) in
            switch result {
            case let .success(data):
                self.catelist.value = data["data"].arrayValue
                if !self.catelist.value.isEmpty {
                    self.currentCateID.value = self.catelist.value[0]["typeid"].stringValue
                }
                self.cateTitlelist.value = self.catelist.value.map({ (item) -> String in
                    return item["name"].stringValue
                })
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchTopiclistSignalProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestQingModuleTopiclist(fid: self.fid, type: self.currentType, cateID: self.currentCateID.value, page: 1)
            .observeResult { (result) in
                switch result {
                case let .success(data):
                    print(data)
                    let list = data["data"]["forumlist"].arrayValue
                    self.topiclist.value = list
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
