//
//  SelectCityViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SelectCityViewModel: NSObject, CityApi {

    override init() {
        super.init()
        
        self.requestCityInfo().observeResult { (result) in
            switch result {
            case let .success(value):
                print(value["data"])
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
