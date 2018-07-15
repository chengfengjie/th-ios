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
    case homeLabelList = "/api-article/v1/label/homeLabelList"
    // 获取首页推荐文章列表
    case homeArticleList = "/api-article/v1/article/queryHomeRecommendArticleList"
    // 获取文章详情
    case getArticleDetail = "/api-article/v1/article/getArticleDetailInfo"
    // 收藏文章
    case articleCollected = "/api-article/v1/article/collect"
    // 取消收藏文章
    case articleCollectCancel = "/api-article/v1/article/collect/cancel"
    // 喜欢文章
    case likeArticle = "/api-article/v1/article/like"
    // 取消喜欢文章
    case likeCancelArticle = "/api-article/v1/article/like/cancel"
    // 评论文章
    case commentArticle = "/api-article/v1/api/article/comment"
    // 文章评论列表
    case articleCommentList = "/api-article/v1/api/article/comment/list"
    // 喜欢文章评论
    case likeArticleComment = "/api-article/v1/api/article/comment/like"
    // 取消喜欢文章评论
    case likeArticleCommentCancel = "/api-article/v1/api/article/comment/like/cancel"
    // 添加笔记
    case articleAddNote = "/api-article/v1/article/note/add"
    // 文章笔记列表
    case articleNoteList = "/api-article/v1/article/note/list"
    // 删除文章笔记
    case deleteArticleNote = "/api-article/v1/article/note/delete"
    // 更新笔记内容
    case updateArticleNote = "/api-article/v1/article/note/update"
    // 获取首页banner列表
    case getArticleBanner = "/api-article/v1/articleHomeBanner/list"
    // 获取文章阅读排行榜
    case getArticleLeaderBoardList = "/api-article/v1/article/leaderBoard/getArticleLeaderBoardList"
    
    // 用户登录
    case userLogin = "/api-user/v1/user/loginRegister"
    // 关注作者
    case attentionAuthor = "/api-user/v1/author/attention"
    // 取消关注作者
    case cancelAttentionAuthor = "/api-user/v1/author/cancelAttention"
    
    // 发送验证码
    case codeSend = "/api-common/v1/sms/sendPhoneCode"

}

