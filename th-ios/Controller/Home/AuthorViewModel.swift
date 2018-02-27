//
//  AuthorViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorViewModel: BaseViewModel, ArticleApi {

    var authorInfo: MutableProperty<JSON>!
    var articlelist: MutableProperty<[JSON]>!
    
    var fetchAurhorInfoAction: Action<(), JSON, RequestError>!
    var fetchArticlelistAction: Action<(AuthorArticleType), [JSON], RequestError>!
    
    let authorID: String
    init(authorID: String) {
        self.authorID = authorID
        super.init()
        
        self.authorInfo = MutableProperty<JSON>(JSON.empty)
        self.articlelist = MutableProperty<[JSON]>([])
        
        self.fetchAurhorInfoAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
            return self.createFetchAuthorInfoSignalProducer()
        })
        
        self.fetchArticlelistAction = Action<(AuthorArticleType), [JSON], RequestError>
            .init(execute: { (type) -> SignalProducer<[JSON], RequestError> in
            return self.createFetchArticlelistSignalProducer(type: type)
        })
        
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.fetchAurhorInfoAction.apply(()).start()
        
        self.fetchArticlelistAction.apply((.news)).start()
    }
    
    private func createFetchAuthorInfoSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestAuthorInfo(authorID: self.authorID).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                let info = data["data"]
                self.authorInfo.value = info
                observer.send(value: info)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.requestError.value = err
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchArticlelistSignalProducer(type: AuthorArticleType) -> SignalProducer<[JSON], RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestAuthorArticlelist(authorID: self.authorID, type: type).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                let list = data["data"]["aAlist"].arrayValue
                self.articlelist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(err):
                self.requestError.value = err
                observer.send(error: err)
            }
        }
        return SignalProducer.init(signal)
    }
}
