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
    /// 取消关注用户
    case cancelFollowUser = "delFollowOne"
    
    /// 获取轻聊首页数据
    case getQingHomeData = "getForum"
    /// 获取轻聊话题列表
    case getQingTopiclist = "getForumType"
    /// 获取轻聊板块首页数据
    case getQingModuleData = "getForumCate"
    /// 获取轻聊模块也分类
    case getQingModuleCatelist = "getForumList"
    /// 获取轻聊板块的话题列表
    case getQingModuleTopiclist = "getForumCatelist"
    /// 获取话题详细信息
    case getTopicInfo = "getThreadInfo"
    /// 获取文章或者话题详情页面的广告
    case getArticleTopicAd = "getAd"
    /// 获取签到信息
    case getSignInfo = "getSign"
    /// 获取验证码
    case getMobileVerCode = "getMobileYzm"
    /// 手机登录
    case login = "getMobileLogin"
    /// 获取个人资料
    case getUserInfo = "getPerData"
    /// 获取个人中心信息
    case getUserCenterInfo = "getPerCenter"
    /// 获取个人中心话题
    case getUserCenterTopic = "getPerThread"
    /// 修改个人资料
    case updateUserInfo = "putPerData"
    /// 修改用户头像
    case updateUserAvatar = "modHeadImage"
    /// 获取用户收藏的文章或者话题
    case getFavoritelist = "getPerFavorite"
    /// 获取用户评论过的话题或文章
    case getUserCommentlist = "getPerComment"
    /// 获取系统消息列表
    case getSystemMessagelist = "getGroupPm"
    /// 获取用户私信记录
    case getUserMessagelist = "getLetterNote"
    /// 获取系统详细信息
    case getSystemMessageInfo = "getGroupPmOne"
    /// 搜索
    case search = "getSearchArticle"
    /// 上传话题图片
    case uploadTopicImage = "upThreadImage"
    /// 发布话题
    case publishTopic = "putForum"
    /// 回复文章评论
    case replayArticleComment = "putPortalCommentToCom"
    /// 获取专题文章列表
    case getSpecialArticlelist = "getArticleSpecial"
    /// 关注作者
    case flowAuthor = "getAuthorFollow"
    /// 设置喜欢文章的状态
    case likeArticleState = "getArticleLike"
    /// 是否喜欢文章评论
    case likeArticleComment = "getArticleTalkLike"
    /// 取消关注作者
    case cancelFollowAuthor = "delAuthorFollow"
    /// 反馈建议
    case feedback = "putfeedback"
    /// 添加文章笔记
    case addArticleNote = "addArticleNote"
    /// 获取私信详情
    case getUserMessageDetaillist = "getLetter"
    /// 修改笔记
    case updateArticleNote = "modArticleNote"
    /// 删除笔记
    case deleteArticleNote = "delArticleNote"
    /// 评论话题
    case commentTopic = "putThread"
    /// 发送私信
    case sendPrivateMessage = "sendLetter"
}
