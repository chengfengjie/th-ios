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
    func requestQingModuleDate(fid: String) -> Signal<JSON, RequestError> {
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
}
