//
//  AuthorListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorListViewModel: NSObject, ArticleApi {
    
    class MenuItem: NSObject {
        let name: String
        var isSelected: Bool
        let catId: String
        init(dataJSON: JSON) {
            self.catId = dataJSON["catid"].stringValue
            self.name = dataJSON["catname"].stringValue
            self.isSelected = false
            super.init()
        }
    }

    @objc dynamic var authorCatelist: [MenuItem] = []
    
    @objc dynamic var authorlist: [Any] = []
    
    var authorJSONlist: [JSON] {
        return self.authorlist as! [JSON]
    }
    
    var currentCateID: String = "" {
        didSet {
            self.fetchData()
        }
    }
    
    override init() {
        super.init()
        
        self.requestAuthorCatelist().observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                self.willChangeValue(forKey: "authorCatelist")
                self.authorCatelist.removeAll()
                value["data"]["catelist"].arrayValue.forEach({ (item) in
                    self.authorCatelist.append(MenuItem.init(dataJSON: item))
                })
                self.authorCatelist.first?.isSelected = true
                if let first = self.authorCatelist.first {
                    self.currentCateID = first.catId
                }
                self.didChangeValue(forKey: "authorCatelist")
            case let .failure(err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchData() {
        self.authorlist = []
        self.requestAuthorlist(cateID: self.currentCateID).observeResult { (result) in
            switch result {
            case let .success(data):
                print(data)
                self.authorlist = data["data"]["cateauthor"].arrayValue
            case let .failure(err):
                print(err.localizedDescription)
            }
        }
    }
    
}
