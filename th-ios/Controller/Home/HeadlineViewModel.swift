//
//  HeadlineViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

class HeadlineViewModel: NSObject, HomeApi {
    
    let cateInfo: JSON
    
    init(cateInfo: JSON) {
        self.cateInfo = cateInfo
        super.init()
        
        self.requestCateArticleData(cateId: self.cateInfo["catid"].stringValue, pageNum: 0)
            .observeResult { (result) in
                
                switch result {
                case let .success(val):
                    print(val)
                case let .failure(err):
                    print(err)
                }
                
        }

    }
}
