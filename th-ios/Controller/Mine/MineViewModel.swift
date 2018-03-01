//
//  MineViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

enum UserAboutType: String {
    case topic = "0"
    case article = "1"
}

class MineViewModel: BaseViewModel, UserApi {
    
    var userAvatar: MutableProperty<URL?>!
    var addressText: MutableProperty<String>!
    var nickNameText: MutableProperty<String>!
    var infoText: MutableProperty<String>!
    
    var topicTotalText: MutableProperty<String>!
    var favoriteTotalText: MutableProperty<String>!
    var commentTotalText: MutableProperty<String>!
    var historyTotalText: MutableProperty<String>!
    
    var userInfoJSON: MutableProperty<JSON>!
    
    var userTopiclist: MutableProperty<[JSON]>!
    
    var userFavoriteTopiclist: MutableProperty<[JSON]>!
    
    var userFavoriteArticlelist: MutableProperty<[JSON]>!
    
    var userCommentTopiclist: MutableProperty<[JSON]>!
    
    var userCommentArticlelist: MutableProperty<[JSON]>!
    
    var settingItemAction: Action<(), SettingViewModel, NoError>!
    
    var messageItemAction: Action<(), MessageListViewModel, NoError>!
    
    var fetchUserInfoAction: Action<(), JSON, RequestError>!
    
    var fetchUserTopicAction: Action<(), [JSON], RequestError>!
    
    var userInfoAction: Action<(), EditUserInfoViewModel, NoError>!
    
    var fetchUserFavoriteAction: Action<UserAboutType, [JSON], RequestError>!
    
    var fetchUserCommentAction: Action<UserAboutType, [JSON], RequestError>!
    
    var currentFavoriteType: MutableProperty<UserAboutType>!
    
    var currentCommentType: MutableProperty<UserAboutType>!
    
    var currentHistoryType: MutableProperty<UserAboutType>!
    
    override init() {
        super.init()
        
        self.userAvatar = MutableProperty<URL?>(nil)
        self.addressText = MutableProperty<String>("")
        self.nickNameText = MutableProperty<String>("")
        self.infoText = MutableProperty<String>("")
        
        self.topicTotalText = MutableProperty("0")
        self.favoriteTotalText = MutableProperty("0")
        self.commentTotalText = MutableProperty("0")
        self.historyTotalText = MutableProperty("0")
        
        self.userTopiclist = MutableProperty<[JSON]>(Array())
        self.userFavoriteTopiclist = MutableProperty<[JSON]>(Array())
        self.userFavoriteArticlelist = MutableProperty<[JSON]>(Array())
        self.userCommentTopiclist = MutableProperty<[JSON]>(Array())
        self.userCommentArticlelist = MutableProperty<[JSON]>(Array())
        
        self.userInfoJSON = MutableProperty<JSON>(JSON.empty)
        
        self.currentFavoriteType = MutableProperty(.topic)
        self.currentCommentType = MutableProperty(.topic)
        self.currentHistoryType = MutableProperty(.topic)
        
        self.settingItemAction = Action<(), SettingViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<SettingViewModel, NoError> in
                return SignalProducer.init(value: SettingViewModel())
        })
        
        self.messageItemAction = Action<(), MessageListViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<MessageListViewModel, NoError> in
                return SignalProducer.init(value: MessageListViewModel())
        })
        
        self.fetchUserInfoAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchUserInfoSinalProducer()
        })
        
        self.fetchUserTopicAction = Action<(), [JSON], RequestError>
            .init(execute: { (_) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchUserTopicSignalProducer()
        })
        
        self.userInfoAction = Action<(), EditUserInfoViewModel, NoError>
            .init(execute: { (_) -> SignalProducer<EditUserInfoViewModel, NoError> in
                return SignalProducer.init(value: EditUserInfoViewModel())
        })
        
        self.fetchUserFavoriteAction = Action<UserAboutType, [JSON], RequestError>
            .init(execute: { (type) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchUserFavoriteSignalProducer(type: type)
        })
        
        self.fetchUserCommentAction = Action<UserAboutType, [JSON], RequestError>
            .init(execute: { (type) -> SignalProducer<[JSON], RequestError> in
                return self.createFetchUserCommentSignalProducer(type: type)
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        fetchUserInfoAction.apply(()).start()
        fetchUserTopicAction.apply(()).start()
        
        currentUser.isLogin.signal.observeValues { (isLogin) in
            if isLogin {
                self.fetchUserInfoAction.apply(()).start()
            }
        }
        
        fetchUserFavoriteAction.apply(currentFavoriteType.value).start()
        currentFavoriteType.signal.observeValues { (val) in
            self.fetchUserFavoriteAction.apply(val).start()
        }
        
        fetchUserCommentAction.apply(currentCommentType.value).start()
        currentCommentType.signal.observeValues { (val) in
            self.fetchUserCommentAction.apply(val).start()
        }
    }
    
    private func createFetchUserInfoSinalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestUserCenterInfo().observeResult { (result) in
            switch result {
            case let .success(val):
                let data: JSON = val["data"]
                self.userAvatar.value = URL.init(string: data["img"].stringValue)
                self.addressText.value = "\(data["resideprovince"].stringValue),\(data["residecity"].stringValue)"
                self.nickNameText.value = data["nickname"].stringValue
                self.infoText.value = "\(data["follower"].stringValue) 粉丝 | \(data["following"].stringValue)关注数"
                self.topicTotalText.value = data["threads"].stringValue
                self.favoriteTotalText.value = data["favoritecount"].stringValue
                self.commentTotalText.value = data["posts"].stringValue
                self.userInfoJSON.value = data
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(err):
                self.requestError.value = err
                observer.send(error: err)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchUserTopicSignalProducer() -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestUserCenterTopic().observeResult { (result) in
            switch result {
            case let .success(val):
                let list = val["data"]["threadslist"].arrayValue
                self.userTopiclist.value = list
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(err):
                self.requestError.value = err
                observer.send(error: err)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchUserFavoriteSignalProducer(type: UserAboutType) -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestUserFavoritelist(type: type.rawValue).observeResult { (result) in
            switch result {
            case let .success(value):
                let list = value["data"]["favlist"].arrayValue
                switch type {
                case .topic:
                    self.userFavoriteTopiclist.value = list
                case .article:
                    self.userFavoriteArticlelist.value = list
                }
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
    private func createFetchUserCommentSignalProducer(type: UserAboutType) -> SignalProducer<[JSON], RequestError> {
        let (signal, observer) = Signal<[JSON], RequestError>.pipe()
        requestUserCommentlist(type: type.rawValue).observeResult { (result) in
            switch result {
            case let .success(value):
                print(value)
                let list = value["data"]["lists"].arrayValue
                switch type {
                case .topic:
                    self.userCommentTopiclist.value = list
                case .article:
                    self.userCommentArticlelist.value = list
                }
                observer.send(value: list)
                observer.sendCompleted()
            case let .failure(error):
                self.requestError.value = error
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
}
