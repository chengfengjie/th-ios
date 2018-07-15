//
//  HeadlineViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeArticleViewModel: BaseViewModel, ArticleClient {
    
    let cateInfo: JSON
        
    var advUrllist: NSMutableArray {
        let array: NSMutableArray = NSMutableArray()
        self.bannerList.value.forEach { (item) in
            if let url = URL.init(string: item["image"].stringValue) {
                array.add(url)
            }
        }
        return array
    }
    
    var articleList: MutableProperty<[JSON]>!
    
    var bannerList: MutableProperty<[JSON]>!
    
    var fetchDataAction: Action<(), [JSON], HttpError>!
    
    var clickArticleCellNodeAction: Action<IndexPath, ArticleDetailViewModel, NoError>!
    
    var getHomeBannerAction: Action<(), JSON, HttpError>!
    
    var pageNum: MutableProperty<Int>!
    
    var isRecommendation: Bool = false
    
    init(cateInfo: JSON) {
        self.cateInfo = cateInfo
        super.init()
        
        self.isRecommendation = self.cateInfo.isEmpty
        
        self.pageNum = MutableProperty(1)
        self.articleList = MutableProperty([])
        self.bannerList = MutableProperty([])
        
        self.clickArticleCellNodeAction = Action<IndexPath, ArticleDetailViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<ArticleDetailViewModel, NoError> in
            let articleID: String = self.articleList.value[indexPath.row]["articleId"].stringValue
            let model: ArticleDetailViewModel = ArticleDetailViewModel(articleID: articleID)
            return SignalProducer<ArticleDetailViewModel, NoError>.init(value: model)
        })
        
        self.getHomeBannerAction = Action.init(execute: { (_) -> SignalProducer<JSON, HttpError> in
            return self.createGetHomeBannerProducer()
        })
        
        self.fetchDataAction = Action.init(execute: { (_) -> SignalProducer<[JSON], HttpError> in
            return self.createFetchDataProducer()
        })
        
    }
    
    func createFetchDataProducer() -> SignalProducer<[JSON], HttpError> {
        let (signal, observer) = Signal<[JSON], HttpError>.pipe()
        if self.cateInfo.isEmpty {
            self.isRequest.value = true
            self.getHomeRecommendArticlelist(page: self.pageNum.value)
                .observeResult { (result) in
                    self.isRequest.value = false
                    switch result {
                    case let .success(data):
                        self.pageNum.value = self.pageNum.value + 1
                        observer.send(value: data["list"].arrayValue)
                        observer.sendCompleted()
                    case let .failure(err):
                        self.httpError.value = err
                        observer.send(error: err)
                    }
            }
        } else {
            self.getHomeLabelArticleList(labelId: self.cateInfo["labelId"].stringValue,
                                         page: self.pageNum.value)
                .observeResult { (result) in
                    
                    switch result {
                    case let .success(data):
                        self.pageNum.value = self.pageNum.value + 1
                        observer.send(value: data["list"].arrayValue)
                        observer.sendCompleted()
                    case let .failure(err):
                        self.httpError.value = err
                        observer.send(error: err)
                    }
            }
        }
        return SignalProducer.init(signal)
    }
    
    func createGetHomeBannerProducer() -> SignalProducer<JSON, HttpError> {
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.getHomeArticleBanner().observeResult { (result) in
            switch result {
            case let .success(data):
                self.bannerList.value = data.arrayValue
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    lazy var leaderboardsViewModel: LeaderboardsViewModel = {
        return LeaderboardsViewModel()
    }()
    
    lazy var authorListViewModel: AuthorListViewModel = {
        return AuthorListViewModel()
    }()
    
    lazy var specialTopiclistViewModel: SpecialListViewModel = {
        return SpecialListViewModel()
    }()
}
