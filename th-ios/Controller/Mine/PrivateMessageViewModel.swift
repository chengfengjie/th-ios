//
//  PrivateMessageViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class PrivateMessageViewModel: BaseViewModel, UserApi {
    
    var fetchDataAction: Action<(), JSON, RequestError>!
    
    var page: MutableProperty<Int>!
    
    let messageData: JSON
    init(messageData: JSON) {
        self.messageData = messageData
        super.init()
        print(messageData)
        
        self.page = MutableProperty(1)
        
        self.fetchDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchDataSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchDataAction.apply(()).start()
    }
    
    private func createFetchDataSignalProducer() -> SignalProducer<JSON, RequestError>  {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestUserMessageDetaillist(touid: self.messageData["authorid"].stringValue, page: self.page.value)
            .observeResult { (result) in
                switch result {
                case let .success(value):
                    print(value)
                case let .failure(error):
                    print(error)
                    self.requestError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }

}
