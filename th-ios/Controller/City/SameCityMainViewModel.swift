//
//  SameCityMainViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityMainViewModel: BaseViewModel, ArticleApi {

    var currentCity: String = "25"
    
    var cateDataProperty: MutableProperty<[JSON]>!
    
    var cateTitles: [String] {
        return self.cateDataProperty.value.map({ (item) -> String in
            return item["catname"].stringValue
        })
    }
    
    var fetchDataAction: Action<Int, [JSON], RequestError>!
    
    override init() {
        super.init()
        self.cateDataProperty = MutableProperty<[JSON]>([])
        
        self.fetchDataAction = Action<Int, [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
            return self.fetchDataProducer()
        })
    }
    
    private func fetchDataProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        self.isRequest.value = true
        self.requestCate(isCity: true, cityName: currentCity).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                self.cateDataProperty.value = value["data"]["catelist"].arrayValue
                observer.send(value: self.cateDataProperty.value)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.errorMsg.value = error.localizedDescription
            }
        }
        return SignalProducer.init(signal)
    }
    
    func getSameCityViewModel(cateIndex: Int) -> SameCityViewModel {
        let data = self.cateDataProperty.value[cateIndex]
        return SameCityViewModel.init(cateID: data["catid"].stringValue)
    }
    
}
