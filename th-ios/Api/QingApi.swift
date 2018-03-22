//
//  QingApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

enum QingModuleTopiclistType: String {
    case news = "0"
    case hot = "1"
    case good = "2"
}

protocol QingApi: ThApi {
}
extension QingApi {
    
    /// 获取轻聊首页数据
    ///
    /// - Returns: Signal
    func requestQingHomeData() -> Signal<JSON, RequestError> {
        return self.request(method: ThMethod.getQingHomeData)
    }
 
    
    /// 获取轻聊模块页面数据
    ///
    /// - Parameter fid: fid
    /// - Returns: Signal
    func requestQingModuleData(fid: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "fid": fid
        ]
        return self.request(method: ThMethod.getQingModuleData, data: params)
    }
    
    
    /// 获取轻聊模块首页的分类雷彪
    ///
    /// - Parameter fid: fid
    /// - Returns: Signal
    func requestQingModuleCatelist(fid: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "fid": fid
        ]
        return self.request(method: ThMethod.getQingModuleCatelist, data: params)
    }
    
    /// 获取轻聊模块的话题列表
    ///
    /// - Parameters:
    ///   - fid: fid
    ///   - type: 类型
    ///   - cateID: 分类
    ///   - page: 页码
    /// - Returns: Signal
    func requestQingModuleTopiclist(fid: String, type: QingModuleTopiclistType, cateID: String, page: Int) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "fid": fid,
            "typeid": type.rawValue,
            "tcateid": cateID,
            "page": page.description
        ]
        return self.request(method: ThMethod.getQingModuleTopiclist, data: params)
    }
    
    /// 获取签到信息
    ///
    /// - Returns: Signal
    func requestSignInfo() -> Signal<JSON, RequestError> {
        return self.request(method: ThMethod.getSignInfo)
    }
    
    
    /// 获取话题列表
    ///
    /// - Parameter type: 0： 最新  1： 我写的  2：我参与的
    /// - Returns: signal
    func requestQingTopiclist(type: Int, page: Int) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "typeid": type.description,
            "page": page.description
        ]
        return request(method: ThMethod.getQingTopiclist, data: params)
    }
    
    /// 获取话题详细信息
    ///
    /// - Parameter tid: 话题ID
    /// - Returns: signal
    func requestQingTopicInfo(tid: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "tid": tid
        ]
        return request(method: ThMethod.getTopicInfo, data: params)
    }
    
    
    /// 上传话题的图片
    ///
    /// - Parameter imageData: 图片data
    /// - Returns: Signal
    func requestUploadTopicImage(dataString: String) -> Signal<JSON, RequestError> {
        let params: [String: Any] = [
            "image": "data:image/png;base64," + dataString
        ]
        return request(method: ThMethod.uploadTopicImage, data: params)
    }
    
    
    /// 发布话题
    ///
    /// - Parameters:
    ///   - fid: 模块ID
    ///   - typeId: 分类ID
    ///   - title: 标题
    ///   - message: 内容
    ///   - pic: 图片
    /// - Returns: Signal
    func requestPublishTopic(
        fid: String, typeId: String, title: String, message:String,
        pic: [String: String]) -> Signal<JSON, RequestError> {
        
        let params: [String: Any] = [
            "fid": fid,
            "typeid": typeId,
            "subject": title,
            "message": message,
            "pic": pic
        ]
        return request(method: ThMethod.publishTopic, data: params)
        
    }
    
    /// 评论话题
    ///
    /// - Parameters:
    ///   - moduleID: 模块id
    ///   - topicId: 话题id
    ///   - message: 评论内容
    /// - Returns: Signal
    func requestCommentTopic(moduleID: String, topicId: String, message: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "fid": moduleID,
            "tid": topicId,
            "message": message
        ]
        return request(method: ThMethod.commentTopic, data: params)
    }
}
