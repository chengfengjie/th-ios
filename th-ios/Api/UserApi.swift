//
//  UserApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol UserApi: ThApi {}

extension UserApi {
    
    
    /// 获取手机验证码
    ///
    /// - Parameter phoneNumber: 手机号码
    /// - Returns: Signal
    func requestMobileCode(phoneNumber: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "phone": phoneNumber
        ]
        return self.request(method: ThMethod.getMobileVerCode, data: params)
    }
    
}
