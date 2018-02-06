//
//  QingViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewModel: NSObject, QingApi {

    var citylist: [JSON] {
        return self.dataJSON["citylist"].arrayValue
    }
    var interestlist: [JSON] {
        return self.dataJSON["interestlist"].arrayValue
    }
    var hotlist: [JSON] {
        return self.dataJSON["hotlist"].arrayValue
    }
    
    @objc dynamic var data: Any? = nil
    var dataJSON: JSON {
        return self.data == nil ? JSON.init([]) : self.data as! JSON
    }
    
    override init() {
        super.init()
        
        self.fetchData()
    }
    
    func fetchData() {
        self.request(method: ThMethod.getQingHomeData).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.data = value["data"]
            case let .failure(error):
                print(error)
            }
        }
    }
}
