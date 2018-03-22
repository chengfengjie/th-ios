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
    
    var articleDetailAction: Action<IndexPath, ArticleDetailViewModel, RequestError>!
    
    var flowUserAction: Action<(), JSON, RequestError>!
    var cancelFlowAuthorAction: Action<(), JSON, RequestError>!
    
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
        
        self.articleDetailAction = Action<IndexPath, ArticleDetailViewModel, RequestError>
            .init(execute: { (indexPath) -> SignalProducer<ArticleDetailViewModel, RequestError> in
                let aId: String = self.articlelist.value[indexPath.row]["aId"].stringValue
                let model: ArticleDetailViewModel = ArticleDetailViewModel(articleID: aId)
                return SignalProducer.init(value: model)
        })
        
        self.flowUserAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFllowUserSignalProducer()
        })
        
        self.cancelFlowAuthorAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createCancelFlowAuthorSignalProducer()
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
    
    private func createFllowUserSignalProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestFlowAuthor(authorId: self.authorID).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                observer.send(value: data)
                observer.sendCompleted()
                self.okMessage.value = "关注成功"
            case let .failure(error):
                observer.send(error: error)
                self.requestError.value = error
            }
            
        }
        return SignalProducer.init(signal)
    }
    
    private func createCancelFlowAuthorSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestCancelFllowAuthor(authorId: self.authorID).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                print(error)
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
}
