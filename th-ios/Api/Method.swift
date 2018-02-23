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
    /// 获取选择城市的城市信息
    case getCityInfo = "getCity"
    /// 获取文章大分类 / 作者分类列表
    case getAuthorCatelist = "getPortalCategory"
    /// 获取作者列表
    case getAuthorlist = "getAuthorCate"
    /// 获取作者详细信息
    case getAuthorInfo = "getAuthorInfo"
    /// 获取作者的文章列表
    case getAuthorArticlelist = "getAuthorArticle"
    /// 评论文章
    case commentArticle = "putPortalComment"
    /// 获取文章评论
    case getArticleCommentlist = "getPortalComment"
    /// 关注用户
    case followUser = "addFollowOne"
    
    /// 获取轻聊首页数据
    case getQingHomeData = "getForum"
    /// 获取轻聊板块首页数据
    case getQingModuleData = "getForumCate"
    /// 获取轻聊模块也分类
    case getQingModuleCatelist = "getForumList"
    /// 获取轻聊板块的话题列表
    case getQingModuleTopiclist = "getForumCatelist"
    /// 获取文章或者话题详情页面的广告
    case getArticleTopicAd = "getAd"
    /// 获取签到信息
    case getSignInfo = "getSign"
    /// 获取验证码
    case getMobileVerCode = "getMobileYzm"
    /// 手机登录
    case login = "getMobileLogin"
}
