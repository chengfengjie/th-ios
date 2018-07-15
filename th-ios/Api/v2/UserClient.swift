//
//  UserClient.swift
//  th-ios
//
//  Created by chengfj on 2018/7/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol UserClient: RestClient {
    
}

extension UserClient {
    
    
    /// 用户登录接口
    ///
    /// - Parameters:
    ///   - phone: 手机号
    ///   - code: 验证码
    /// - Returns: signal
    func userLogin(phone: String, code: String) -> Signal<JSON, HttpError> {
        let parameters: [String: String] = [
            "code": code,
            "phone": phone
        ]
        return self.request(requestURI: RequestURI.userLogin, parameters: parameters, method: HTTPMethod.post)
    }
    
    
    /// 发送验证码
    ///
    /// - Parameter phone: 手机号
    /// - Returns: signal
    func codeSend(phone: String) -> Signal<JSON, HttpError> {
        let parameters: [String: String] = [
            "phone": phone,
            "type": "login"
        ]
        return self.request(requestURI: RequestURI.codeSend, parameters: parameters, method: HTTPMethod.get)
    }
    
    
    /// 关注作者
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - authorId: 作者ID
    /// - Returns: signal
    func attentionAuthor(userId: String, authorId: String) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "userId": userId,
            "authorId": authorId
        ]
        return self.request(requestURI: RequestURI.attentionAuthor, parameters: params, method: HTTPMethod.get)
    }
    
    
    /// 取消关注作者
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - authorId: 作者ID
    /// - Returns: signal
    func cancelAttentionAuthor(userId: String, authorId: String) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "userId": userId,
            "authorId": authorId
        ]
        return self.request(requestURI: RequestURI.cancelAttentionAuthor, parameters: params, method: HTTPMethod.get)
    }
}
