//
//  SameCityViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SameCityViewModel: NSObject, ArticleApi {

    var pageNume: Int = 1
    
    @objc dynamic var articlelist: [Any] = []
    
    var advUrllist: NSMutableArray = NSMutableArray()
    
    let cateID: String
    init(cateID: String) {
        self.cateID = cateID
        super.init()
        
        self.fetchData()
    }
    
    func fetchData() {
        self.requestCateArticleData(cateId: self.cateID, pageNum: self.pageNume).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.advUrllist.removeAllObjects()
                let advlist: [JSON] = value["data"]["advlist"].arrayValue
                advlist.forEach({ (item) in
                    if let url: URL = URL.init(string: item["url"].stringValue) {
                        print(url)
                        self.advUrllist.add(url)
                    }
                })
                self.articlelist = value["data"]["articlelist"].arrayValue
            case let .failure(error):
                print(error)
            }
        }
    }
}
