//
//  HomeViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeViewModel: BaseViewModel, ArticleApi, ArticleClient {
    
    lazy var cateDataProperty: MutableProperty<[JSON]> = {
        return MutableProperty.init([])
    }()
    lazy var fetchCateDataAction: Action<Int, [JSON], HttpError> = {
        return Action<Int, [JSON], HttpError>.init(execute: { (input) ->
            SignalProducer<[JSON], HttpError> in
            return SignalProducer.init(self.fetchSaveCateDatalist())
        })
    }()
    
    var searchAction: Action<(), SearchViewModel, NoError>!
            
    override init() {
        super.init()
        
        self.searchAction = Action<(), SearchViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<SearchViewModel, NoError> in
                return SignalProducer.init(value: SearchViewModel())
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchCateDataAction.apply(0).start()
    }
    
    private func fetchSaveCateDatalist() -> Signal<[JSON], HttpError> {
        return self.getHomeLabelList().map({ (data) -> [JSON] in
            self.cateDataProperty.value = data.arrayValue
            print(data.arrayValue)
            return []
        })
    }
    
    func createHomeArticleViewModel(cateIndex: Int) -> HomeArticleViewModel {
        if cateIndex == 0 {
            return HomeArticleViewModel.init(cateInfo: JSON.empty)
        } else {
            let cateData: JSON = self.cateDataProperty.value[cateIndex - 1]
            return HomeArticleViewModel.init(cateInfo: cateData)
        }
    }
}
