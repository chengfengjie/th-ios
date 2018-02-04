//
//  ApiMethod.swift
//  th-ios
//
//  Created by chengfj on 2018/2/1.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

enum ThMethod: String {
    /// 获取首页分类
    case getCate = "getCate"
    /// 获取首页分类文章列表
    case getHomeCateList = "getIndexCate"
    /// 获取阅读排行榜
    case getArticleHotToplist = "getArticleHot"
    /// 专题
    case getSpeciallist = "getSpecialInfo"
    /// 文章详细信息
    case getArticleInfo = "getArticleInfo"
}
