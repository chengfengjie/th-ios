//
//  QingViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewModel: BaseViewModel, QingApi {

    var citylist: [JSON] {
        return self.dataJSON["citylist"].arrayValue
    }
    var interestlist: [JSON] {
        return self.dataJSON["interestlist"].arrayValue
    }
    var hotlist: [JSON] {
        return self.dataJSON["hotlist"].arrayValue
    }
    
    var signInfoProperty: MutableProperty<JSON> = MutableProperty<JSON>.init(JSON.emptyJSON)
    
    @objc dynamic var data: Any? = nil
    var dataJSON: JSON {
        return self.data == nil ? JSON.init([]) : self.data as! JSON
    }
    
    override init() {
        super.init()
        
        self.fetchData()
        
        self.fetchSignData()
    }
    
    func fetchData() {
        self.request(method: ThMethod.getQingHomeData).observeResult { (result) in
            switch result {
            case let .success(value):
                self.data = value["data"]
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchSignData() {
        self.requestSignInfo().observeResult { (result) in
            switch result {
            case let .success(data):
                self.signInfoProperty.value = data["data"]
            case let .failure(error):
                NSLog("%s", error.localizedDescription)
            }
        }
    }
    
    var signViewModel: SignViewModel {
        return SignViewModel.init(signInfo: self.signInfoProperty.value)
    }
}
