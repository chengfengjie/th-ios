//
//  QingViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewModel: BaseViewModel, QingApi {

    var citylist: [JSON] {
        return self.qingIndexData.value["citylist"].arrayValue
    }
    var interestlist: [JSON] {
        return self.qingIndexData.value["interestlist"].arrayValue
    }
    var hotlist: [JSON] {
        return self.qingIndexData.value["hotlist"].arrayValue
    }
    
    var qingIndexData: MutableProperty<JSON>!
    var signInfoProperty: MutableProperty<JSON>!
    
    var fetchQingIndexDataAction: Action<(), JSON, RequestError>!
    var fetchSignDataAction: Action<(), JSON, RequestError>!
    
    var signAction: Action<(), SignViewModel, NoError>!
    
    var topiclistAction: Action<TopicListType, QingTopicListViewModel, RequestError>!
    
    override init() {
        super.init()
        
        self.qingIndexData = MutableProperty(JSON.emptyJSON)
        self.signInfoProperty = MutableProperty(JSON.emptyJSON)
        
        self.fetchQingIndexDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchDataSignalProducer()
        })
        
        self.fetchSignDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchSignDataSignalProducer()
        })
        
        self.signAction = Action<(), SignViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<SignViewModel, NoError> in
            return SignalProducer.init(value: SignViewModel(signInfo: self.signInfoProperty.value))
        })
        
        self.topiclistAction = Action<TopicListType, QingTopicListViewModel, RequestError>
            .init(execute: { (type) -> SignalProducer<QingTopicListViewModel, RequestError> in
                if self.currentUser.isLogin.value {
                    return SignalProducer.init(value: QingTopicListViewModel(type: type))
                } else {
                    return SignalProducer.init(error: RequestError.forbidden)
                }
            })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchQingIndexDataAction.apply(()).start()
        self.fetchSignDataAction.apply(()).start()
    }
    
    private func createFetchDataSignalProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.request(method: ThMethod.getQingHomeData).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                let data = value["data"]
                self.qingIndexData.value = data
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.errorMsg.value = error.localizedDescription
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchSignDataSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.requestSignInfo().observeResult { (result) in
            switch result {
            case let .success(data):
                print("-----"+data.description)
                let aData = data["data"]
                self.signInfoProperty.value = aData
                observer.send(value: aData)
                observer.sendCompleted()
            case let .failure(error):
                self.errorMsg.value = error.localizedDescription
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
}
