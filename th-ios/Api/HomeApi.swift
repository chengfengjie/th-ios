//
//  HomeApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

enum HotToplistType: String {
    case day = "0"
    case week = "1"
    case month = "2"
}

enum AuthorArticleType: String {
    case news
    case hot
    case comment
}

protocol ArticleApi: ThApi {}

extension ArticleApi {
    
    
    /// 获取首页分类
    ///
    /// - Parameters:
    ///   - isCity: 是否特定城市
    ///   - cityName: 城市名称
    func requestCate(isCity: Bool = false, cityName: String = "") -> Signal<JSON, RequestError> {
        var params: [String: Any] = [:]
        if isCity {
            params["cityName"] = cityName
        }
        params["isCity"] = isCity ? "0" : "1"
        return self.request(method: ThMethod.getCate, data: params)
    }
    
    
    /// 获取首页文章列表
    ///
    /// - Parameters:
    ///   - cateId: 分类ID
    ///   - pageNum: 页码
    /// - Returns: result
    func requestCateArticleData(cateId: String, pageNum: Int) -> Signal<JSON, RequestError> {
        let params: [String: Any] = [
            "catid": cateId,
            "page": pageNum.description
        ]
        return self.request(method: ThMethod.getHomeCateList, data: params)
    }
    
    /// 获取阅读排行榜列表
    ///
    /// - Parameter hotType: 类型
    /// - Returns: 信号
    func requestArtcleHotToplist(hotType: HotToplistType) -> Signal<JSON, RequestError> {
        let params: [String: Any] = [
            "hottype": hotType.rawValue
        ]
        return self.request(method: ThMethod.getArticleHotToplist, data: params)
    }

    
    /// 专题列表
    ///
    /// - Returns: rignal
    func requestSpeciallist() -> Signal<JSON, RequestError> {
        return self.request(method: ThMethod.getSpeciallist)
    }
    
    /// 文章详情
    ///
    /// - Parameters:
    ///   - articleID: 文章ID
    ///   - userID: 用户ID
    /// - Returns: signal
    func requestArticleInfo(articleID: String, userID: String) -> Signal<JSON, RequestError> {
        let params = [
            "aid": articleID,
            "uid": userID,
        ]
        return self.request(method: ThMethod.getArticleInfo, data: params)
    }
    
    
    /// 获取作者分类列表
    ///
    /// - Returns: signal
    func requestAuthorCatelist() -> Signal<JSON, RequestError> {
        return self.request(method: ThMethod.getAuthorCatelist)
    }
    
    
    /// 获取作者列表
    ///
    /// - Parameter cateID: 分类ID
    /// - Returns: Signal
    func requestAuthorlist(cateID: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "catid": cateID
        ]
        return self.request(method: ThMethod.getAuthorlist, data: params)
    }
    
    
    /// 获取作者详细信息
    ///
    /// - Parameter authorID: 作者ID
    /// - Returns: Signal
    func requestAuthorInfo(authorID: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "auid": authorID
        ]
        return self.request(method: ThMethod.getAuthorInfo, data: params)
    }
    
    
    /// 获取作者文章列表
    ///
    /// - Parameters:
    ///   - authorID: 作者ID
    ///   - type: 类型描述
    /// - Returns: Signal
    func requestAuthorArticlelist(authorID: String, type: AuthorArticleType) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "auid": authorID,
            "autype": type.rawValue
        ]
        return request(method: ThMethod.getAuthorArticlelist, data: params)
    }
}
