//
//  SystemMessageViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SystemMessageViewModel: BaseViewModel, UserApi {

    var fetchDataAction: Action<(), JSON, RequestError>!
    
    lazy var pmid: String = {
        return messageData["pmid"].stringValue
    }()
    
    let messageData: JSON
    init(messageData: JSON) {
        self.messageData = messageData
        super.init()
        
        self.fetchDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchDataSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchDataAction.apply(()).start()
    }
    
    private func createFetchDataSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestSystemMessageInfo(pmid: self.pmid).observeResult { (result) in
            self.isRequest.value = false
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
