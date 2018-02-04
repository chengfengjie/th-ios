//
//  SpecialTopicListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class SpecialTopicListViewModel: NSObject, HomeApi{
    
    @objc dynamic var speciallist: [Any] = []
    
    var specilaJsonList: [JSON] {
        return self.speciallist as! [JSON]
    }
    
    override init() {
        super.init()
        
        self.requestSpeciallist().observeResult { (result) in
            switch result {
            case let .success(val):
                print(val)
                self.speciallist = val["data"]["speciallist"].arrayValue
            case let .failure(err):
                print(err)
            }
        }
    }
    
}
