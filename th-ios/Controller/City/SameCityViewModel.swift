//
//  SameCityViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityViewModel: BaseViewModel, ArticleApi {

    var pageNume: Int = 1
    
    var articlelistProperty: MutableProperty<[JSON]>!
    var adUrlArrayProperty: MutableProperty<NSMutableArray>!
    var adlistProperty: MutableProperty<[JSON]>!
    
    var fetchDataAction: Action<Int, [JSON], RequestError>!
    
    var clickArticleAction: Action<IndexPath, ArticleDetailViewModel, NoError>!
    
    let cateID: String
    init(cateID: String) {
        self.cateID = cateID
        super.init()
        
        self.articlelistProperty = MutableProperty<[JSON]>.init([])
        self.adUrlArrayProperty = MutableProperty<NSMutableArray>.init(NSMutableArray.init())
        self.adlistProperty = MutableProperty<[JSON]>.init([])
        
        self.fetchDataAction = Action<Int, [JSON], RequestError>
            .init(execute: { (page) -> SignalProducer<[JSON], RequestError> in
                return self.fetchDataProducer(page: page)
        })
        
        self.clickArticleAction = Action<IndexPath, ArticleDetailViewModel, NoError>
            .init(execute: { (indexPath) -> SignalProducer<ArticleDetailViewModel, NoError> in
                let aid: String = self.articlelistProperty.value[indexPath.row]["aid"].stringValue
                let viewModel = ArticleDetailViewModel(articleID: aid)
                return SignalProducer.init(value: viewModel)
        })
    }
    
    func fetchDataProducer(page: Int) ->  SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        self.requestCateArticleData(cateId: self.cateID, pageNum: self.pageNume).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.articlelistProperty.value = value["data"]["articlelist"].arrayValue
                self.adlistProperty.value =  value["data"]["advlist"].arrayValue
                let array: NSMutableArray = NSMutableArray()
                self.adlistProperty.value.forEach({ (item) in
                    if let url: URL = URL.init(string: item["url"].stringValue) {
                        array.add(url)
                    }
                })
                self.adUrlArrayProperty.value = array
                observer.send(value: self.articlelistProperty.value)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
            }
        }
        return  SignalProducer<[JSON], RequestError>.init(signal)
    }
}
