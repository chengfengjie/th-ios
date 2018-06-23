//
//  CommonApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/9.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol CommonApi: ThApi {}
extension CommonApi {
    
    
    /// 获取文章详情页面的广告图
    ///
    /// - Parameter cateID: 分类ID
    /// - Returns: Signal
    func requestArticleAd(cateID: String) -> Signal<JSON, RequestError> {
        let params:[String: String] = [
            "catid": cateID,
            "targets": "0",
            "style": "0",
            "isall": "0"
        ]
        return self.request(method: ThMethod.getArticleTopicAd, data: params)
    }
    
    
    /// 获取话题详情页面的广告图
    ///
    /// - Parameter cateID: 分类ID
    /// - Returns: Signal
    func requestTopicAd(topicID: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "catid": topicID,
            "targets": "1",
            "style": "0",
            "isall": "0"
        ]
        return self.request(method: ThMethod.getArticleTopicAd, data: params)
    }
    
    
    /// 搜索文章
    ///
    /// - Parameters:
    ///   - keyWord: 关键字
    ///   - page: 分页
    /// - Returns: Signal
    func requestSearchArticle(keyWord: String, page: Int) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "tkey": keyWord,
            "page": page.description,
            "type": "0"
        ]
        return request(method: ThMethod.search, data: params)
    }
    
    /// 搜索话题
    ///
    /// - Parameters:
    ///   - keyWord: 关键字
    ///   - page: 分页
    /// - Returns: Signal
    func requestSearchTopic(keyWord: String, page: Int) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "tkey": keyWord,
            "page": page.description,
            "type": "1"
        ]
        return request(method: ThMethod.search, data: params)
    }
    
}
