//
//  HomeApi.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol HomeApi: ThApi {}

extension HomeApi {
    
    
    /// 获取首页分类
    ///
    /// - Parameters:
    ///   - isCity: 是否特定城市
    ///   - cityName: 城市名称
    func requestCate(isCity: Bool = false, cityName: String = "") -> Signal<JSON, RequestError> {
        var params: [String: Any] = [:]
        if isCity {
            params["isCity"] = "1"
            params["cityName"] = cityName
        }
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
}
