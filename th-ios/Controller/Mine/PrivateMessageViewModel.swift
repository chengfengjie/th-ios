//
//  PrivateMessageViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class PrivateMessageViewModel: BaseViewModel, UserApi {
    
    var messageText: MutableProperty<String>!
    
    var fetchDataAction: Action<(), JSON, RequestError>!
    
    var sendMessageAction: Action<(), IndexPath, RequestError>!
    
    var page: MutableProperty<Int>!
    
    var pmlist: MutableProperty<[JSON]>!
    
    var toUserAvatar: MutableProperty<String>!
    
    var mineAvatar: MutableProperty<String>!
    
    let messageData: JSON
    init(messageData: JSON) {
        self.messageData = messageData
        super.init()
        print(messageData)
        
        self.page = MutableProperty(1)
        
        self.messageText = MutableProperty("")
        
        self.pmlist = MutableProperty([])
        
        self.toUserAvatar = MutableProperty("")
        
        self.mineAvatar = MutableProperty("")
        
        self.fetchDataAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createFetchDataSignalProducer()
        })
        
        self.sendMessageAction = Action<(), IndexPath, RequestError>
            .init(execute: { (_) -> SignalProducer<IndexPath, RequestError> in
                return self.createSendMessageSignalProducer()
        })
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        self.fetchDataAction.apply(()).start()
    }
    
    private func createFetchDataSignalProducer() -> SignalProducer<JSON, RequestError>  {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        requestUserMessageDetaillist(touid: self.messageData["authorid"].stringValue, page: self.page.value)
            .observeResult { (result) in
                switch result {
                case let .success(value):
                    print(value)
                    self.pmlist.value = value["data"]["letterlist"].arrayValue.filter({ (item) -> Bool in
                        return !item["message"].stringValue.isEmpty
                    })
                    self.toUserAvatar.value = value["data"]["touserimg"].stringValue
                    self.mineAvatar.value = value["data"]["userimg"].stringValue
                    observer.send(value: value)
                    observer.sendCompleted()
                case let .failure(error):
                    print(error)
                    self.requestError.value = error
                    observer.send(error: error)
                }
        }
        return SignalProducer.init(signal)
    }

    private func createSendMessageSignalProducer() -> SignalProducer<IndexPath, RequestError> {
        let (signal, observer) = Signal<IndexPath, RequestError>.pipe()
        let message: String = self.messageText.value
        let dict: [String: String] = [
            "message": message,
            "msgfromid": UserModel.current.userID.value,
            "dateline": Date().timeIntervalSince1970.description
        ]
        self.pmlist.value.append(JSON.init(dict))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            observer.send(value: IndexPath.init(row: self.pmlist.value.count - 1, section: 0))
            observer.sendCompleted()
        }
        requestSendPrivateMessage(toUserId: self.messageData["authorid"].stringValue,
                                  message: message)
            .observeResult { (result) in
                switch result {
                case let .success(value):
                    print(value)
                case let .failure(error):
                    print(error)
                }
        }
        return SignalProducer.init(signal)
    }
}
