//
//  SearchViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/2.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SearchViewModel: BaseViewModel, CommonApi {

    var searchArticleAction: Action<(), JSON, RequestError>!
    
    var keyWord: MutableProperty<String>!
    
    var currentPage: MutableProperty<Int>!
    
    var articlelist: MutableProperty<[JSON]>!
    
    var currentTab: MutableProperty<String>!
    
    var articleDetailAction: Action<IndexPath, ArticleDetailViewModel, NoError>!
    
    var searchTopicAction: Action<(), JSON, RequestError>!
    
    var searchAction: Action<(), JSON, RequestError>!
    
    override init() {
        super.init()
        self.tableStyle = .plain
        
        self.keyWord = MutableProperty("")
        
        self.currentPage = MutableProperty(1)
        
        self.articlelist = MutableProperty([])
        
        self.currentTab = MutableProperty("0")
        
        self.articleDetailAction = Action<IndexPath, ArticleDetailViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<ArticleDetailViewModel, NoError> in
                return SignalProducer.init(value: ArticleDetailViewModel(articleID: ""))
        })
        
        self.searchArticleAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createSearchArticleSignalProducer()
        })
        
        self.searchTopicAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createSearchTopicSignalProducer()
        })
        
        self.searchAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                if self.currentTab.value == "0" {
                    self.searchTopicAction.apply(()).start()
                } else {
                    self.searchArticleAction.apply(()).start()
                }
                return SignalProducer.empty
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        self.currentTab.signal.observeValues { (tab) in
            if !self.keyWord.value.isEmpty {
                self.searchAction.apply(()).start()
            }
        }
    }
    
    private func createSearchArticleSignalProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestSearchArticle(keyWord: self.keyWord.value, page: self.currentPage.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                self.articlelist.value = value["data"]["searchlist"].arrayValue
                observer.send(value: value)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createSearchTopicSignalProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestSearchTopic(keyWord: self.keyWord.value, page: self.currentPage.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                print(value)
                self.articlelist.value = value["data"]["searchlist"].arrayValue
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
