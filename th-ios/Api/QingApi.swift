//
//  QingApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol QingApi: ThApi {
}
extension QingApi {
    
    /// 获取轻聊首页数据
    ///
    /// - Returns: Signal
    func requestQingHomeData() -> Signal<JSON, RequestError> {
        return self.request(method: ThMethod.getQingHomeData)
    }
    
}
