//
//  SpecialTopicViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/9.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SpecialViewModel: BaseViewModel, ArticleApi {
    
    var fetchArticlelistAction: Action<(), JSON, RequestError>!
    
    var articlelist: MutableProperty<[JSON]>!

    let specialInfo: JSON
    init(specialInfo: JSON) {
        self.specialInfo = specialInfo
        super.init()
        
        self.articlelist = MutableProperty<[JSON]>.init([])
        
        self.fetchArticlelistAction =  Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchArticlelistSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchArticlelistAction.apply(()).start()
    }
    
    private func createFetchArticlelistSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestSpecialArticlelist(specialId: self.specialInfo["topicid"].stringValue, page: 1)
            .observeResult { (result) in
            switch result {
            case let .success(value):
                let articlelist: [JSON] = value["data"]["speciallist"].arrayValue
                print(articlelist)
                self.articlelist.value = articlelist
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
