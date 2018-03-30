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
    
    /// 手机号登录
    ///
    /// - Parameters:
    ///   - phone: 手机号
    ///   - code: 验证码
    /// - Returns: signal
    func requestLogin(phone: String, code: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "phone": phone,
            "yzm": code
        ]
        return self.request(method: ThMethod.login, data: params)
    }

    /// 关注用户
    ///
    /// - Parameter userID: 用户id
    /// - Returns: Signal
    func requestFllowUser(userID: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "fuid": userID
        ]
        return self.request(method: ThMethod.followUser, data: params)
    }

    /// 获取个人信息
    ///
    /// - Returns: Signal
    func requestUserInfo() -> Signal<JSON, RequestError> {
        return request(method: ThMethod.getUserInfo)
    }
    
    
    /// 获取个人中心个个人信息
    ///
    /// - Returns: Signal
    func requestUserCenterInfo() -> Signal<JSON, RequestError> {
        return request(method: ThMethod.getUserCenterInfo)
    }
    
    
    /// 获取个人中心话题
    ///
    /// - Returns: Signal
    func requestUserCenterTopic() -> Signal<JSON, RequestError> {
        return request(method: ThMethod.getUserCenterTopic)
    }
    
    
    /// 更新个人信息
    ///
    /// - Parameters:
    ///   - nickName: 昵称
    ///   - province: 省份
    ///   - city: 城市
    ///   - bio: 个人简介
    /// - Returns: Signal
    func requestUpdateUserInfo(nickName: String,
                               province: String,
                               city: String,
                               bio: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "nickname": nickName,
            "resideprovince": province,
            "residecity": city,
            "bio": bio
        ]
        return request(method: .updateUserInfo, data: params)
    }
    
    
    /// 获取用户关注的话题或者文章
    ///
    /// - Parameter type: 类型 0 话题  1 文章
    /// - Returns: Signal
    func requestUserFavoritelist(type: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "idtype": type
        ]
        return request(method: .getFavoritelist, data: params)
    }
    
    /// 获取用户评论过的文章或者话题
    ///
    /// - Parameter type: 类型 0 话题  1 文章
    /// - Returns: Signal
    func requestUserCommentlist(type: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "type": type
        ]
        return request(method: ThMethod.getUserCommentlist, data: params)
    }
    
    /// 获取系统消息列表
    ///
    /// - Returns: Signal
    func requestSystemMessagelist() -> Signal<JSON, RequestError> {
        return request(method: ThMethod.getSystemMessagelist)
    }
    
    /// 获取用户私信
    ///
    /// - Returns: Signal
    func requestUserMessagelist() -> Signal<JSON, RequestError> {
        return request(method: ThMethod.getUserMessagelist)
    }
    
    
    /// 获取系统消息记录详细信息
    ///
    /// - Parameter pmid: 消息ID
    /// - Returns: Signal
    func requestSystemMessageInfo(pmid: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "pmid": pmid
        ]
        return request(method: ThMethod.getSystemMessageInfo, data: params)
    }
    
    /// 反馈
    ///
    /// - Parameters:
    ///   - text: 文本反馈
    ///   - image: 图片反馈
    /// - Returns: Signal
    func requestFeedback(text: String?, image: UIImage?) -> Signal<JSON, RequestError> {
        var params: [String: String] = [:]
        if text != nil {
            params["text"] = text!
        }
        if image != nil {
            params["image"] = self.encodeImage(image: image!)
        }
        return request(method: ThMethod.feedback, data: params)
    }
    
    /// 获取私信详细列表
    ///
    /// - Parameters:
    ///   - touid: 用户id
    ///   - page: 分页
    /// - Returns: signal
    func requestUserMessageDetaillist(touid: String, page: Int) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "touid": touid,
            "page": page.description
        ]
        return request(method: ThMethod.getUserMessageDetaillist, data: params)
    }
    
    /// 取消关注用户
    ///
    /// - Parameter userId: 用户id
    /// - Returns: Siganl
    func requestCancelFollowUser(userId: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "fuid": userId
        ]
        return request(method: ThMethod.cancelFollowUser, data: params)
    }
    
    /// 发送私信
    ///
    /// - Parameters:
    ///   - toUserId: 发送给用户id
    ///   - message: 消息内容
    /// - Returns: Signal
    func requestSendPrivateMessage(toUserId: String, message: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "toid": toUserId,
            "message": message,
            "subject": ""
        ]
        return request(method: ThMethod.sendPrivateMessage, data: params)
    }
}
