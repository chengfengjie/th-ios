//
//  EditUserInfoViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/25.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class EditUserInfoViewModel: BaseViewModel, UserApi {
    
    var userAvatar: MutableProperty<URL?>!
    var nickName: MutableProperty<String>!
    var bio: MutableProperty<String>!
    var province: MutableProperty<String>!
    var residecity: MutableProperty<String>!
    
    var saveAction: Action<(), JSON, RequestError>!
    
    override init() {
        super.init()
        
        self.userAvatar = MutableProperty<URL?>(nil)
        self.nickName = MutableProperty<String>("深海巨鲨")
        self.bio = MutableProperty<String>("这是一个比较好的乌龟")
        self.province = MutableProperty<String>("四川")
        self.residecity = MutableProperty<String>("成都")
        
        self.saveAction = Action<(), JSON, RequestError>
            .init(execute: { (_) -> SignalProducer<JSON, RequestError> in
                return self.createSaveDataAction()
        })
    }
    
    private func createSaveDataAction() -> SignalProducer<JSON, RequestError> {
        let (siganl, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        requestUpdateUserInfo(nickName: self.nickName.value,
                              province: self.province.value,
                              city: self.residecity.value,
                              bio: self.bio.value)
            .observeResult { (result) in
                
                self.isRequest.value = false
                
                switch result {
                case let .success(val):
                    print(val)
                case let .failure(err):
                    self.requestError.value = err
                    observer.send(error: err)
                }
                    
        }
        return SignalProducer.init(siganl)
    }

}
