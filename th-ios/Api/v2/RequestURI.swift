//
//  RequestURI.swift
//  th-ios
//
//  Created by chengfj on 2018/6/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

enum RequestURI: String {

    // 获取首页标签列表
    case homeLabelList = "/article/v1/label/homeLabelList"
    // 获取首页推荐文章列表
    case homeArticleList = "/article/v1/article/queryHomeRecommendArticleList"
    
}
