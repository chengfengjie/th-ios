//
//  ArticleDetailViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class ArticleDetailViewModel: NSObject, ArticleApi {
    
    @objc dynamic var data: Any? = nil
    var dataJSON: JSON {
        if self.data == nil {
            return JSON.init([:])
        } else {
            return self.data as! JSON
        }
    }
    
    var relatedlist: [JSON] {
        return self.dataJSON["sRelated"].arrayValue
    }
    
    let articleID: String
    init(articleID: String) {
        self.articleID = "85"
        super.init()
        
        requestArticleInfo(articleID: self.articleID, userID: "").observeResult { (result) in
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
