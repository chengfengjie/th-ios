//
//  CityApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol CityApi: ThApi {
    
}

extension CityApi {
    
    /// 获取选择城市界面的城市信息
    ///
    /// - Returns: signal
    func requestCityInfo() -> Signal<JSON, RequestError> {
        return self.request(method: ThMethod.getCityInfo)
    }
    
}
