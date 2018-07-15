//
//  ArticleDetailViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class ArticleDetailViewModel: BaseViewModel, CommonApi, ArticleClient, UserClient {
    
    var articleData: MutableProperty<JSON>!
    var adData: MutableProperty<JSON>!

    var relatedlist: [JSON] {
        return self.articleData.value["sRelated"].arrayValue
    }
    
    var fetchArticleDataAction: Action<(), JSON, RequestError>!
    
    var collectArticleAction: Action<(), JSON, HttpError>!
    
    var commentTotalAction: Action<(), ArticleCommentListViewModel, NoError>!
    
    var commentAction: Action<(), CommentArticleViewModel, HttpError>!
    
    var likeArticleAction: Action<(), JSON, HttpError>!
    
    var followAuthorAction: Action<(), JSON, HttpError>!
    
    var cancelFollowAuthorAction: Action<(), JSON, HttpError>!
    
    var shareAction: Action<JSON, JSON, NoError>!
    
    var islike: MutableProperty<Bool>!
    var isCollect: MutableProperty<Bool>!
    var commentTotal: MutableProperty<Int>!
    
    let articleID: String
    init(articleID: String) {
        self.articleID = articleID
        super.init()
    
        self.articleData = MutableProperty<JSON>(JSON.empty)
        self.adData = MutableProperty<JSON>(JSON.empty)
        
        self.islike = MutableProperty<Bool>.init(false)
        self.isCollect = MutableProperty.init(false)
        self.commentTotal = MutableProperty.init(0)
        
        self.fetchArticleDataAction = Action<(), JSON, RequestError>
            .init(execute: { (input) -> SignalProducer<JSON, RequestError> in
            return self.createFetchArticleDataProducer()
        })
        
        self.commentTotalAction = Action<(), ArticleCommentListViewModel, NoError>
            .init(execute: { (tulp) -> SignalProducer<ArticleCommentListViewModel, NoError> in
                let model = self.commentViewModel
                model.commentTotal.value = self.commentTotal.value
                return SignalProducer.init(value: model)
        })

        self.commentAction = Action<(), CommentArticleViewModel, HttpError>
            .init(execute: { (tulp) -> SignalProducer<CommentArticleViewModel, HttpError> in
                if self.currentUser.isLogin.value {
                    let model = self.commentArticleViewModel
                    model.commentAction.values.observeValues({ (data) in
                        self.commentTotal.value = self.commentTotal.value + 1
                    })
                    return SignalProducer.init(value: model)
                } else {
                    self.httpError.value = HttpError.forbidden
                    return SignalProducer.init(error: HttpError.forbidden)
                }

        })
        
        self.collectArticleAction = Action<(), JSON, HttpError>
            .init(execute: { (_) -> SignalProducer<JSON, HttpError> in
                if !UserModel.current.isLogin.value {
                    self.httpError.value = HttpError.forbidden
                    return SignalProducer.init(error: HttpError.forbidden)
                } else if self.isCollect.value {
                    return self.createCancelCollectArticleProducer()
                } else {
                    return self.createCollectArticleProducer()
                }
        })
        
        self.likeArticleAction = Action<(), JSON, HttpError>
            .init(execute: { (_) -> SignalProducer<JSON, HttpError> in
                if self.currentUser.isLogin.value {
                    return self.createlikeArticleSignalProducer(isLike: self.islike.value)
                } else {
                    return SignalProducer.init(error: HttpError.forbidden)
                }
        })

        self.followAuthorAction = Action<(), JSON, HttpError>
            .init(execute: { (_) -> SignalProducer<JSON, HttpError> in
                if self.currentUser.isLogin.value {
                    return self.createAttentionAuthorSignalProducer()
                } else {
                    self.httpError.value = HttpError.forbidden
                    return SignalProducer.empty
                }
        })

        self.cancelFollowAuthorAction = Action<(), JSON, HttpError>
            .init(execute: { (_) -> SignalProducer<JSON, HttpError> in
                if self.currentUser.isLogin.value {
                    return self.createCancelAuthorSignalProducer()
                } else {
                    self.httpError.value = HttpError.forbidden
                    return SignalProducer.empty
                }
        })
        
        self.shareAction = Action.init(execute: { (data) -> SignalProducer<JSON, NoError> in
            return SignalProducer.init(value: data)
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
    }
    
    private func createFetchArticleDataProducer() -> SignalProducer<JSON, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.getArticleDetail(articleId: self.articleID).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                self.articleData.value = data
                self.commentTotal.value = data["commentTotal"].intValue
                self.islike.value = data["isLike"].boolValue
                self.isCollect.value = data["isCollect"].boolValue
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(err):
                print(err)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createCollectArticleProducer() -> SignalProducer<JSON, HttpError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.articleCollect(articleId: self.articleID, userId: UserModel.current.userID.value)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    print(data)
                    self.isCollect.value = true
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    print(error)
                }
        }
        return SignalProducer.init(signal)
    }
    
    private func createCancelCollectArticleProducer() -> SignalProducer<JSON, HttpError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.articleCollectCancel(articleId: self.articleID, userId: UserModel.current.userID.value)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    print(data)
                    self.isCollect.value = false
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    print(error)
                }
        }
        return SignalProducer.init(signal)
    }
    
    func createlikeArticleSignalProducer(isLike: Bool) -> SignalProducer<JSON, HttpError> {
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.isRequest.value = true
        if !isLike {
            self.likeArticle(articleId: self.articleID, userId: UserModel.current.userID.value).observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    print(data)
                    self.islike.value = true
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                    observer.send(error: error)
                }
            }
        } else {
            self.likeCancelArticle(articleId: self.articleID, userId: UserModel.current.userID.value).observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    print(data)
                    self.islike.value = false
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                }
            }
        }
        return SignalProducer.init(signal)
    }

    func createAttentionAuthorSignalProducer() -> SignalProducer<JSON, HttpError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.attentionAuthor(userId: UserModel.current.userID.value,
                             authorId: self.articleData.value["authorId"].stringValue)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }

    func createCancelAuthorSignalProducer() -> SignalProducer<JSON, HttpError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.cancelAttentionAuthor(userId: UserModel.current.userID.value,
                                   authorId: self.articleData.value["authorId"].stringValue)
            .observeResult { (result) in
                self.isRequest.value = false
                switch result {
                case let .success(data):
                    observer.send(value: data)
                    observer.sendCompleted()
                case let .failure(error):
                    self.httpError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }
}
