//
//  ArticleDetailViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class ArticleDetailViewModel: BaseViewModel, ArticleApi, CommonApi {
    
    var articleData: MutableProperty<JSON>!
    var adData: MutableProperty<JSON>!

    var relatedlist: [JSON] {
        return self.articleData.value["sRelated"].arrayValue
    }
    
    var fetchArticleDataAction: Action<(), JSON, RequestError>!
    
    var fetchAdDataAction: Action<(), JSON, RequestError>!
    
    let articleID: String
    init(articleID: String) {
        self.articleID = "85"
        super.init()
    
        self.articleData = MutableProperty<JSON>(JSON.emptyJSON)
        self.adData = MutableProperty<JSON>(JSON.emptyJSON)
        
        self.fetchArticleDataAction = Action<(), JSON, RequestError>
            .init(execute: { (input) -> SignalProducer<JSON, RequestError> in
            return self.createFetchArticleDataProducer()
        })
        
        self.fetchAdDataAction = Action<(), JSON, RequestError>
            .init(execute: { (input) -> SignalProducer<JSON, RequestError> in
            return self.createFetchAdDataProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchArticleDataAction.values.observeValues { [weak self] (_) in
            self?.fetchAdDataAction.apply(()).start()
        }
    }
    
    private func createFetchArticleDataProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestArticleInfo(articleID: self.articleID, userID: self.currentUser.userID.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                let data = value["data"]
                self.articleData.value = data
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.errorMsg.value = error.localizedDescription
            }
        }
        return SignalProducer.init(signal)
    }
    
    func createFetchAdDataProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.requestArticleAd(cateID: self.articleData.value["sCateid"].stringValue)
            .observeResult { (result) in
                switch result {
                case let .success(data):
                    let list = data["data"]["advlist"]
                    self.adData.value = list
                    observer.send(value: list)
                    observer.sendCompleted()
                case let .failure(error):
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }
}
