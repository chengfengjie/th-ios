//
//  LeaderboardsViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class LeaderboardsViewModel: NSObject, HomeApi {
    
    var type: HotToplistType = HotToplistType.day {
        didSet {
            self.fetchData()
        }
    }
    
    @objc dynamic var dayToplist: [Any] = []
    @objc dynamic var weekToplist: [Any] = []
    @objc dynamic var monthToplist: [Any] = []
    
    var currentData: [JSON] {
        switch self.type {
        case .day:
            return self.dayToplist as! [JSON]
        case .week:
            return self.weekToplist as! [JSON]
        case .month:
            return self.monthToplist as! [JSON]
        }
    }
    
    override init() {
        super.init()
        
        self.fetchData()
    }
    
    func fetchData() {
        self.requestArtcleHotToplist(hotType: self.type).observeResult { (result) in
            switch result {
            case let .success(val):
                print(val)
                switch self.type {
                case .day:
                    self.dayToplist = val["data"]["hotlist"].arrayValue
                case .month:
                    self.monthToplist = val["data"]["hotlist"].arrayValue
                case .week:
                    self.weekToplist = val["data"]["hotlist"].arrayValue
                }
            case let .failure(err):
                print(err)
            }
        }
    }
    
}
