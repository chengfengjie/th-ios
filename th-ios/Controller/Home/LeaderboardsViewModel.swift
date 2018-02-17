//
//  LeaderboardsViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class LeaderboardsViewModel: BaseViewModel, ArticleApi {
    
    var type: HotToplistType = HotToplistType.day {
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
    
    var fetchDataAction: Action<Int, [JSON], RequestError>!
    
    override init() {
        super.init()
        
        self.dayToplistProperty = MutableProperty<[JSON]>([])
        self.weekToplistProperty = MutableProperty<[JSON]>([])
        self.monthToplistProperty = MutableProperty<[JSON]>([])
        
        self.fetchDataAction = Action<Int, [JSON], RequestError>.init(execute: { (val) -> SignalProducer<[JSON], RequestError> in
            return self.fetchDataProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.type = .day
    }
    
    func fetchDataProducer() -> SignalProducer<[JSON], RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        self.requestArtcleHotToplist(hotType: self.type).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(val):
                switch self.type {
                case .day:
                    self.dayToplistProperty.value = val["data"]["hotlist"].arrayValue
                case .month:
                    self.monthToplistProperty.value = val["data"]["hotlist"].arrayValue
                case .week:
                    self.weekToplistProperty.value = val["data"]["hotlist"].arrayValue
                }
                observer.send(value: self.currentData)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.errorMsg.value = err.localizedDescription
            }
        }
        return SignalProducer<[JSON], RequestError>.init(signal)
    }
    
}
