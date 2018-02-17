//
//  SpecialTopicListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class SpecialTopicListViewModel: BaseViewModel, ArticleApi{
    
    var speciallist: MutableProperty<[JSON]>!
    
    var fetchlistAction: Action<Int, [JSON], RequestError>!
    
    override init() {
        super.init()
        
        self.speciallist = MutableProperty<[JSON]>([])
        
        self.fetchlistAction = Action<Int, [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
            return self.fetchlistProducer()
        })
        
        self.fetchlistAction.apply(0).start()
        
    }
    
    private func fetchlistProducer() -> SignalProducer<[JSON], RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        self.requestSpeciallist().observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(val):
                let list = val["data"]["speciallist"].arrayValue
                self.speciallist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.errorMsg.value = err.localizedDescription
            }
        }
        return SignalProducer.init(signal)
    }
    
}
