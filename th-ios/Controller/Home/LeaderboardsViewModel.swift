//
//  LeaderboardsViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class LeaderboardsViewModel: BaseViewModel, ArticleClient {
    
    var type: LeaderBoardType = LeaderBoardType.day {
        didSet {
            self.fetchDataAction.apply(0).start()
        }
    }
    
    var currentData: [JSON] {
        switch self.type {
        case .day:
            return self.dayToplistProperty.value
        case .week:
            return self.weekToplistProperty.value
        case .month:
            return self.monthToplistProperty.value
        }
    }

    var dayToplistProperty: MutableProperty<[JSON]>!
    var weekToplistProperty: MutableProperty<[JSON]>!
    var monthToplistProperty: MutableProperty<[JSON]>!
    
    var fetchDataAction: Action<Int, [JSON], HttpError>!
    
    var clickAritlceAction: Action<IndexPath, ArticleDetailViewModel, NoError>!
    
    override init() {
        super.init()
        
        self.tableStyle = .plain
        
        self.dayToplistProperty = MutableProperty<[JSON]>([])
        self.weekToplistProperty = MutableProperty<[JSON]>([])
        self.monthToplistProperty = MutableProperty<[JSON]>([])
        
        self.fetchDataAction = Action<Int, [JSON], HttpError>.init(execute: { (val) -> SignalProducer<[JSON], HttpError> in
            return self.fetchDataProducer()
        })
        
        self.clickAritlceAction = Action<IndexPath, ArticleDetailViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<ArticleDetailViewModel, NoError> in
                let articleID: String = self.currentData[indexPath.row]["articleId"].stringValue
                let model: ArticleDetailViewModel = ArticleDetailViewModel(articleID: articleID)
                return SignalProducer.init(value: model)
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.type = .day
    }
    
    func fetchDataProducer() -> SignalProducer<[JSON], HttpError> {
        if self.currentData.isEmpty {
            self.isRequest.value = true
        } else {
            return SignalProducer.empty
        }
        let (signal, observer) = Signal<[JSON], HttpError>.pipe()
        self.getArticleLeaderBoardList(type: self.type).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(val):
                switch self.type {
                case .day:
                    self.dayToplistProperty.value = val.arrayValue
                case .month:
                    self.monthToplistProperty.value = val.arrayValue
                case .week:
                    self.weekToplistProperty.value = val.arrayValue
                }
                observer.send(value: self.currentData)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.httpError.value = err
            }
        }
        return SignalProducer<[JSON], HttpError>.init(signal)
    }
    
}
