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
}
