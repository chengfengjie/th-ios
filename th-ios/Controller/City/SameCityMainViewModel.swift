//
//  SameCityMainViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityMainViewModel: BaseViewModel, ArticleApi {
    
    var cateDataProperty: MutableProperty<[JSON]>!
    
    var selectCityAction: Action<(), SelectCityViewModel, RequestError>!
    
    var cateTitles: [String] {
        return self.cateDataProperty.value.map({ (item) -> String in
            return item["catname"].stringValue
        })
    }
    
    var fetchDataAction: Action<Int, [JSON], RequestError>!
    
    var searchAction: Action<(), SearchViewModel, NoError>!
    
    override init() {
        super.init()
        self.cateDataProperty = MutableProperty<[JSON]>([])
        
        self.fetchDataAction = Action<Int, [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
            return self.fetchDataProducer()
        })
        
        self.selectCityAction = Action<(), SelectCityViewModel, RequestError>
            .init(execute: { (_) -> SignalProducer<SelectCityViewModel, RequestError> in
                return SignalProducer.init(value: SelectCityViewModel())
        })
        
        self.currentUser.currentCityId.signal.observeValues { (id) in
            self.fetchDataAction.apply(0).start()
        }
        
        self.searchAction = Action<(), SearchViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<SearchViewModel, NoError> in
                return SignalProducer.init(value: SearchViewModel())
            })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchDataAction.apply(0).start()
    }
    
    private func fetchDataProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        self.isRequest.value = true
        self.requestCate(isCity: true, cityName: self.currentUser.currentCityId.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(value):
                self.cateDataProperty.value = value["data"]["catelist"].arrayValue
                observer.send(value: self.cateDataProperty.value)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.requestError.value = error
            }
        }
        return SignalProducer.init(signal)
    }
    
    func getSameCityViewModel(cateIndex: Int) -> SameCityViewModel {
        let data = self.cateDataProperty.value[cateIndex]
        return SameCityViewModel.init(cateID: data["catid"].stringValue)
    }
    
}
