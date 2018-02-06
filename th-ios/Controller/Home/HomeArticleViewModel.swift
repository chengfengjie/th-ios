//
//  HeadlineViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeArticleViewModel: NSObject, ArticleApi {
    
    let cateInfo: JSON
    
    @objc dynamic var articleData: [Any] = []
    
    @objc dynamic var adData: [Any] = []
    
    var advUrllist: NSMutableArray = NSMutableArray()
    
    init(cateInfo: JSON) {
        self.cateInfo = cateInfo
        super.init()
        
        self.requestData()
    }
    
    func requestData() {
        self.requestCateArticleData(cateId: self.cateInfo["catid"].stringValue, pageNum: 1)
            .observeResult { (result) in
                switch result {
                case let .success(val):
                    self.advUrllist.removeAllObjects()
                    let advlist: [JSON] = val["data"]["advlist"].arrayValue
                    advlist.forEach({ (item) in
                        if let url: URL = URL.init(string: item["url"].stringValue) {
                            print(url)
                            self.advUrllist.add(url)
                        }
                    })
                    self.articleData = val["data"]["articlelist"].arrayValue
                    self.adData = val["data"]["advlist"].arrayValue
                case let .failure(err):
                    print(err)
                }
        }
    }
}
