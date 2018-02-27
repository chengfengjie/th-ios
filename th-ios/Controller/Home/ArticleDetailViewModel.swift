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
    
    var commentTotalAction: Action<(), ArticleCommentListViewModel, NoError>!
    
    var commentAction: Action<(), CommentArticleViewModel, RequestError>!
    
    let articleID: String
    init(articleID: String) {
        self.articleID = "85"
        super.init()
    
        self.articleData = MutableProperty<JSON>(JSON.empty)
        self.adData = MutableProperty<JSON>(JSON.empty)
        
        self.fetchArticleDataAction = Action<(), JSON, RequestError>
            .init(execute: { (input) -> SignalProducer<JSON, RequestError> in
            return self.createFetchArticleDataProducer()
        })
        
        self.fetchAdDataAction = Action<(), JSON, RequestError>
            .init(execute: { (input) -> SignalProducer<JSON, RequestError> in
            return self.createFetchAdDataProducer()
        })
        
        self.commentTotalAction = Action<(), ArticleCommentListViewModel, NoError>
            .init(execute: { (tulp) -> SignalProducer<ArticleCommentListViewModel, NoError> in
            return SignalProducer.init(value: self.commentViewModel)
        })
        
        self.commentAction = Action<(), CommentArticleViewModel, RequestError>
            .init(execute: { (tulp) -> SignalProducer<CommentArticleViewModel, RequestError> in
                if self.currentUser.isLogin.value {
                    return SignalProducer.init(value: self.commentArticleViewModel)
                } else {
                    return SignalProducer.init(error: RequestError.forbidden)
                }
            
        })
    }
    
    private lazy var commentViewModel: ArticleCommentListViewModel = {
        return ArticleCommentListViewModel(articleID: self.articleID)
    }()
    
    private var commentArticleViewModel: CommentArticleViewModel {
        return CommentArticleViewModel(articleID: self.articleID)
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
                self.requestError.value = error
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
