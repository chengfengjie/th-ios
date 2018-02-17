//
//  AuthorViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorViewModel: BaseViewModel, ArticleApi {
    
    @objc dynamic var authorData: Any? = nil
    var authorDataJSON: JSON {
        return self.authorData == nil ? JSON.init([:]) : self.authorData as! JSON
    }
    
    var currentType: AuthorArticleType = .news {
        didSet {
            self.fetchData()
        }
    }
    
    @objc dynamic var articleData: [Any] = []
    
    let authorID: String
    init(authorID: String) {
        self.authorID = authorID
        super.init()
        
        self.requestAuthorInfo(authorID: self.authorID).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
                self.authorData = data["data"]
            case let .failure(err):
                print(err.localizedDescription)
            }
        }
        
        self.fetchData()
    }
    
    func fetchData() {
        self.requestAuthorArticlelist(authorID: self.authorID, type: self.currentType).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
            case let .failure(err):
                print(err.localizedDescription)
            }
        }
    }
}
