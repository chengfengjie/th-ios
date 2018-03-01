//
//  MessageListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MessageListViewModel: BaseViewModel, UserApi {

    var systemMessagelist: MutableProperty<[JSON]>!
    var userMessagelist: MutableProperty<[JSON]>!
    
    var fetchSystemMessageAction: Action<(), [JSON], RequestError>!
    
    var fetchUserMessageAction: Action<(), [JSON], RequestError>!
    
    var systemCellNodeAction: Action<IndexPath, SystemMessageViewModel, NoError>!
    
    var userMessageCellNodeAction: Action<IndexPath, PrivateMessageViewModel, NoError>!
    
    override init() {
        super.init()
        
        self.systemMessagelist = MutableProperty<[JSON]>.init([])
        self.userMessagelist = MutableProperty<[JSON]>.init([])
        
        self.fetchSystemMessageAction = Action<(), [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchSystemMessageSignalProducer()
        })
        
        self.fetchUserMessageAction = Action<(), [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchUserMessageSignalProducer()
        })
        
        self.systemCellNodeAction = Action<IndexPath, SystemMessageViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<SystemMessageViewModel, NoError> in
                let model =  SystemMessageViewModel(messageData: self.systemMessagelist.value[indexPath.row])
                return SignalProducer.init(value: model)
        })
        
        self.userMessageCellNodeAction = Action<IndexPath, PrivateMessageViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<PrivateMessageViewModel, NoError> in
                let model = PrivateMessageViewModel(messageData: self.userMessagelist.value[indexPath.row])
                return SignalProducer.init(value: model)
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchSystemMessageAction.apply(()).start()
        self.fetchUserMessageAction.apply(()).start()
    }
    
    private func createFetchSystemMessageSignalProducer() -> SignalProducer<[JSON], RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestSystemMessagelist().observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                let list = value["data"]["grouplist"].arrayValue
                self.systemMessagelist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchUserMessageSignalProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestUserMessagelist().observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                let list = value["data"]["pmlist"].arrayValue
                self.userMessagelist.value = list
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
