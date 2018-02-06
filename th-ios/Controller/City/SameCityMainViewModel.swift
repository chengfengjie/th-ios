//
//  SameCityMainViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityMainViewModel: NSObject, ArticleApi {

    var currentCity: String = "25"
    
    @objc dynamic var cateData: [Any] = []
    
    var cateTitles: [String] {
        return cateData.map({ (item) -> String in
            return (item as! JSON)["catname"].stringValue
        })
    }
    
    override init() {
        super.init()
        
        self.fetchData()
    }
    
    func fetchData() {
        self.requestCate(isCity: true, cityName: currentCity).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.cateData = value["data"]["catelist"].arrayValue
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
