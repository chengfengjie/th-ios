//
//  HomeViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject, ArticleApi {
    
    @objc dynamic var cateData: [Any] = []
            
    override init() {
        super.init()
        
        self.requestCate().observeResult { (res) in
            switch res {
            case let .success(val):
                self.cateData = val["data"]["catelist"].arrayValue
            case let .failure(err):
                print(err)
            }
        }
    }
    
}
