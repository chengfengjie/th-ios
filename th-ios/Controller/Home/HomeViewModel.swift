//
//  HomeViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeViewModel: BaseViewModel, ArticleApi {
    
    lazy var cateDataProperty: MutableProperty<[JSON]> = {
        return MutableProperty.init([])
    }()
    lazy var fetchCateDataAction: Action<Int, [JSON], RequestError> = {
        return Action<Int, [JSON], RequestError>.init(execute: { (input) ->
            SignalProducer<[JSON], RequestError> in
            return SignalProducer.init(self.fetchSaveCateDatalist())
        })
    }()
            
    override init() {
        super.init()
        self.fetchCateDataAction.apply(0).start()
    }
    
    private func fetchSaveCateDatalist() -> Signal<[JSON], RequestError> {
        self.isRequest.value = true
        return self.requestCate().map({ (data) -> [JSON] in
            self.isRequest.value = false
            let result: [JSON] = data["data"]["catelist"].arrayValue
            self.cateDataProperty.value = result
            return result
        })
    }
    
    func createHomeArticleViewModel(cateIndex: Int) -> HomeArticleViewModel {
        let cateData: JSON = self.cateDataProperty.value[cateIndex]
        return HomeArticleViewModel.init(cateInfo: cateData)
    }
}
