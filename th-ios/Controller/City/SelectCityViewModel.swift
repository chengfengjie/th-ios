//
//  SelectCityViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SelectCityViewModel: BaseViewModel, CityApi {

    var recommendCitylist: MutableProperty<[JSON]>!
    
    var citylist: MutableProperty<[JSON]>!
    
    var fetchCityDataAction: Action<(), JSON, RequestError>!
    
    var selectCityAction: Action<IndexPath, JSON, NoError>!
    
    override init() {
        super.init()
        
        self.recommendCitylist = MutableProperty<[JSON]>.init([])
        self.citylist = MutableProperty<[JSON]>([])
        
        self.fetchCityDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchDataSignalProducer()
        })
        
        self.selectCityAction = Action<IndexPath, JSON, NoError>
            .init(execute: { (indexPath) -> SignalProducer<JSON, NoError> in
                if indexPath.section == 0 {
                    self.currentUser.currentCityName.value = self.recommendCitylist.value[indexPath.row]["catname"].stringValue
                    self.currentUser.currentCityId.value = self.recommendCitylist.value[indexPath.row]["catid"].stringValue
                } else {
                    self.currentUser.currentCityName.value = self.citylist.value[indexPath.row]["catname"].stringValue
                    self.currentUser.currentCityId.value = self.citylist.value[indexPath.row]["catid"].stringValue
                }
                return SignalProducer.empty
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchCityDataAction.apply(()).start()
    }
    
    private func createFetchDataSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.requestCityInfo().observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.recommendCitylist.value = value["data"]["tjcitylist"].arrayValue
                self.citylist.value = value["data"]["citylist"].arrayValue
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
