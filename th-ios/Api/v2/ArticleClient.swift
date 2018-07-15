//
//  ArticleClient.swift
//  th-ios
//
//  Created by chengfj on 2018/6/7.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol ArticleClient: RestClient {
    
}

enum LeaderBoardType: String {
    case day = "1"
    case week = "2"
    case month = "3"
}

extension ArticleClient {
    
    
    /// 获取首页标签列表
    ///
    /// - Returns: list
    func getHomeLabelList() -> Signal<JSON, HttpError> {
        return self.request(requestURI: RequestURI.homeLabelList, method: HTTPMethod.get)
    }
    
    
    /// 获取首页推荐文章列表
    ///
    /// - Parameter page: 分页
    /// - Returns: list
    func getHomeRecommendArticlelist(page: Int) -> Signal<JSON, HttpError> {
        let params: [String: Any] = [
            "isRecommendation": 1,
            "pageNum": page,
            "pageSize": 30
        ]
        return self.request(requestURI: RequestURI.homeArticleList, parameters: params, method: HTTPMethod.post)
    }
    
    
    /// 通过labelId获取首页文章列表
    ///
    /// - Parameters:
    ///   - labelId: labelId
    ///   - page: 分页
    /// - Returns: list
    func getHomeLabelArticleList(labelId: String, page: Int) -> Signal<JSON, HttpError> {
        let params: [String: Any] = [
            "pageNum": page,
            "labelId": labelId,
            "pageSize": 30
        ]
        return self.request(requestURI: RequestURI.homeArticleList, parameters: params, method: HTTPMethod.post)
    }
    
    
    /// 获取文章详细信息
    ///
    /// - Parameter articleId: 文章ID
    /// - Returns: list
    func getArticleDetail(articleId: String) -> Signal<JSON, HttpError> {
        var params: [String: Any] = [
            "articleId": articleId
        ]
        if !UserModel.current.userID.value.isEmpty {
            params["userId"] = UserModel.current.userID.value
        }
        return self.request(requestURI: RequestURI.getArticleDetail, parameters: params, method: HTTPMethod.get)
    }
    
    
    /// 收藏文章
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - userId: 用户ID
    /// - Returns: result
    func articleCollect(articleId: String, userId: String) -> Signal<JSON, HttpError> {
        let paramters: [String: String] = [
            "articleId": articleId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.articleCollected, parameters: paramters, method: HTTPMethod.post)
    }
    
    /// 取消收藏文章
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - userId: 用户ID
    /// - Returns: result
    func articleCollectCancel(articleId: String, userId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "articleId": articleId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.articleCollectCancel, parameters: parameter, method: HTTPMethod.post)
    }
    
    
    /// 喜欢文章
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - userId: 用户ID
    /// - Returns: signal
    func likeArticle(articleId: String, userId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "articleId": articleId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.likeArticle, parameters: parameter, method: HTTPMethod.post)
    }
    
    /// 取消喜欢文章
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - userId: 用户ID
    /// - Returns: signal
    func likeCancelArticle(articleId: String, userId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "articleId": articleId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.likeCancelArticle, parameters: parameter, method: HTTPMethod.post)
    }
    
    
    /// 评论文章
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - content: 内容
    ///   - userId: 用户ID
    /// - Returns: signal
    func commentArticle(articleId: String, content: String, userId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "articleId": articleId,
            "content": content,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.commentArticle, parameters: parameter, method: HTTPMethod.post)
    }
    
    
    /// 回复文章评论
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - content: 评论内容
    ///   - userId: 用户ID
    ///   - commentId: 评论ID
    /// - Returns: signal
    func replyComment(articleId: String, content: String, userId: String, commentId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "articleId": articleId,
            "content": content,
            "userId": userId,
            "parentCommentId": commentId,
            "replyCommentId": commentId
        ]
        return self.request(requestURI: RequestURI.commentArticle, parameters: parameter, method: HTTPMethod.post)
    }
    
    /// 文章评论列表
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - pageNum: 分页
    /// - Returns: signal
    func getArticleCommentList(articleId: String, pageNum: Int) -> Signal<JSON, HttpError> {
        var parameter: [String: String] = [
            "articleId": articleId,
            "pageNum": pageNum.description,
            "pageSize": "100"
        ]
        if UserModel.current.isLogin.value {
            parameter["userId"] = UserModel.current.userID.value
        }
        return self.request(requestURI: RequestURI.articleCommentList, parameters: parameter, method: HTTPMethod.post)
    }
    
    
    /// 喜欢文章评论
    ///
    /// - Parameters:
    ///   - commentId: 评论ID
    ///   - userId: 用户ID
    /// - Returns: signal
    func likeArticleComment(commentId: String, userId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "commentId": commentId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.likeArticleComment, parameters: parameter, method: HTTPMethod.get)
    }
    
    
    /// 取消喜欢文章评论
    ///
    /// - Parameters:
    ///   - commentId: 评论ID
    ///   - userId: 用户ID
    /// - Returns: signal
    func cancelLikeArticleComment(commentId: String, userId: String) -> Signal<JSON, HttpError> {
        let parameter: [String: String] = [
            "commentId": commentId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.likeArticleCommentCancel, parameters: parameter, method: HTTPMethod.get)
    }
    
    
    /// 给文章添加笔记
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - content: 笔记内容
    ///   - sectionId: 段落ID
    ///   - userId: 用户ID
    /// - Returns: signal
    func articleAddNote(articleId: String, content: String, sectionId: String, userId: String) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "articleId": articleId,
            "content": content,
            "sectionId": sectionId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.articleAddNote, parameters: params, method: HTTPMethod.post)
    }
    
    
    /// 获取文章笔记
    ///
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - sectionId: 段落ID
    ///   - userId: 用户ID
    /// - Returns: signal
    func articleNoteList(articleId: String, sectionId: String, userId: String) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "articleId": articleId,
            "sectionId": sectionId,
            "userId": userId
        ]
        return self.request(requestURI: RequestURI.articleNoteList, parameters: params, method: HTTPMethod.get)
    }
    
    
    /// 删除文章笔记
    ///
    /// - Parameter noteId: 笔记ID
    /// - Returns: signal
    func deleteArticleNote(noteId: String) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "id": noteId
        ]
        return self.request(requestURI: RequestURI.deleteArticleNote, parameters: params, method: HTTPMethod.get)
    }
    
    
    /// 更新笔记
    ///
    /// - Parameters:
    ///   - noteId: 笔记ID
    ///   - content: 内容
    /// - Returns: signal
    func updateArticleNote(noteId: String, content: String) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "id": noteId,
            "content": content
        ]
      return self.request(requestURI: RequestURI.updateArticleNote, parameters: params, method: HTTPMethod.post)
    }
    
    
    /// 获取首页banenr
    ///
    /// - Returns: list
    func getHomeArticleBanner() -> Signal<JSON, HttpError> {
        return self.request(requestURI: RequestURI.getArticleBanner, method: HTTPMethod.get)
    }
    
    
    /// 获取文章排行榜列表
    ///
    /// - Parameter type: type
    /// - Returns: signal
    func getArticleLeaderBoardList(type: LeaderBoardType) -> Signal<JSON, HttpError> {
        let params: [String: String] = [
            "type": type.rawValue
        ]
        return self.request(requestURI: RequestURI.getArticleLeaderBoardList, parameters: params, method: HTTPMethod.get)
    }
}
