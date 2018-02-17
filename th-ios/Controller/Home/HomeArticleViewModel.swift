//
//  HeadlineViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HomeArticleViewModel: BaseViewModel, ArticleApi {
    
    let cateInfo: JSON
        
    var advUrllist: NSMutableArray {
        let array: NSMutableArray = NSMutableArray()
        self.adDataProperty.value.forEach { (item) in
            if let url = URL.init(string: item["url"].stringValue) {
                array.add(url)
            }
        }
        return array
    }
    lazy var articleDataProperty: MutableProperty<[JSON]> = {
        return MutableProperty<[JSON]>.init([])
    }()
    lazy var adDataProperty: MutableProperty<[JSON]> = {
        return MutableProperty<[JSON]>.init([])
    }()
    
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
                    print(val)
                    self.adDataProperty.value = val["data"]["advlist"].arrayValue
                    self.articleDataProperty.value = val["data"]["articlelist"].arrayValue
                case let .failure(err):
                    print(err)
                }
        }
    }
    
    lazy var leaderboardsViewModel: LeaderboardsViewModel = {
        return LeaderboardsViewModel()
    }()
    
    lazy var authorListViewModel: AuthorListViewModel = {
        return AuthorListViewModel()
    }()
    
    lazy var specialTopiclistViewModel: SpecialTopicListViewModel = {
        return SpecialTopicListViewModel()
    }()
    
}
