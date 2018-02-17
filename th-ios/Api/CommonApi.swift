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
    func requestTopicAd(cateID: String) -> Signal<JSON, RequestError> {
        let params: [String: String] = [
            "catid": cateID,
            "targets": "1",
            "style": "0",
            "isall": "0"
        ]
        return self.request(method: ThMethod.getArticleTopicAd, data: params)
    }
    
}