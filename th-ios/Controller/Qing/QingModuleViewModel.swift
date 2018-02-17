//
//  QingModuleViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingModuleViewModel: BaseViewModel, QingApi {
    
    @objc dynamic var data: Any? = nil
    var dataJSON: JSON {
        return self.data == nil ? JSON.init([]) : self.data as! JSON
    }
    
    @objc dynamic var catelist: [Any] = []
    var cateJSONlist: [JSON] {
        return self.catelist as! [JSON]
    }
    var cateTitlelist: [String] {
        return self.cateJSONlist.map({ (json) -> String in
            return json["name"].stringValue
        })
    }

    
    var toplist: [JSON] {
        return self.dataJSON["toplist"].arrayValue
    }
    
    var cateID: String = "" {
        didSet {
            self.requestTopiclist()
        }
    }
    
    
    var currentType: QingModuleTopiclistType = .news
    
    @objc dynamic var topiclist: [Any] = []
    var topicJSONlist: [JSON] {
        return self.topiclist as! [JSON]
    }
    
    let fid: String
    init(fid: String) {
        self.fid = fid
        super.init()
        
        self.requestQingModuleDate(fid: self.fid).observeResult { (result) in
            switch result {
            case let .success(value):
                self.data = value["data"]
            case let .failure(error):
                print(error)
            }
        }
        
        self.requestCatelist()
    }
    
    func requestCatelist() {
        self.requestQingModuleCatelist(fid: self.fid).observeResult { (result) in
            switch result {
            case let .success(data):
                self.catelist = data["data"].arrayValue
                if !self.cateJSONlist.isEmpty {
                    self.cateID = self.cateJSONlist[0]["typeid"].stringValue
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func requestTopiclist() {
        self.requestQingModuleTopiclist(fid: self.fid, type: self.currentType, cateID: self.cateID, page: 1)
            .observeResult { (result) in
                switch result {
                case let .success(data):
                    print(data)
                    self.topiclist = data["data"]["forumlist"].arrayValue
                case let .failure(error):
                    print(error)
                }
                
        }
    }
    
    
}
