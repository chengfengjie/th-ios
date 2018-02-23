//
//  QingTopicListViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/23.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

enum TopicListType: Int {
    case news = 100
    case published = 101
    case attented = 102
    case viewhistory = 103
        
    func getTitle() -> String {
        switch self {
        case .news:
            return "最新话题"
        case .published:
            return "我发表的话题"
        case .attented:
            return "我参与的话题"
        case .viewhistory:
            return "最近浏览"
        }
    }
}

class QingTopicListViewModel: BaseViewModel {
    
    let type: TopicListType
    init(type: TopicListType) {
        self.type = type
        super.init()
    }
    
}
