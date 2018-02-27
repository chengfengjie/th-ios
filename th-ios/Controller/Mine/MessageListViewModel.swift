//
//  MessageListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MessageListViewModel: BaseViewModel, UserApi {

    var fetchSystemMessageAction: Action<(), [JSON], RequestError>!
    
    var fetchUserMessageAction: Action<(), [JSON], RequestError>!
    
    override init() {
        super.init()
        
        self.fetchSystemMessageAction = Action<(), [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchSystemMessageSignalProducer()
        })
        
        self.fetchUserMessageAction = Action<(), [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchUserMessageSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchSystemMessageAction.apply(()).start()
        self.fetchUserMessageAction.apply(()).start()
    }
    
    private func createFetchSystemMessageSignalProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestSystemMessagelist().observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
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
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
}
