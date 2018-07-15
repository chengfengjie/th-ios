//
//  AuthorizeInputCodeViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorizeInputCodeViewModel: BaseViewModel, UserClient {
    
    var inputCode: MutableProperty<String>!
    
    var loginAction: Action<String, JSON, HttpError>!
    
    let cellPhone: String
    let code: String
    init(phone: String, code: String) {
        self.cellPhone = phone
        self.code = code
        super.init()
        
        print(code)
        
        self.inputCode = MutableProperty(code)
        
        self.loginAction = Action<String, JSON, HttpError>
            .init(execute: { (code) -> SignalProducer<JSON, HttpError> in
            return self.createLoginSignalProducer()
        })
        
        self.inputCode.signal.observeValues { (val) in
            self.loginAction.apply(val).start()
        }
    
    }
    
    private func createLoginSignalProducer() -> SignalProducer<JSON, HttpError> {
        let (signal, observer) = Signal<JSON, HttpError>.pipe()
        self.isRequest.value = true
        self.userLogin(phone: self.cellPhone, code: self.code).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                UserModel.current.isLogin.value = true
                if let url = URL.init(string: data["avatar"].stringValue) {
                    UserModel.current.avatar.value = url
                }
                UserModel.current.userID.value = data["userId"].stringValue
                UserModel.current.email.value = data["email"].stringValue
                UserModel.current.userName.value = data["nickName"].stringValue
                UserModel.current.token.value = data["token"].stringValue
                UserModel.saveCurrentUser()
                self.okMessage.value = "登录成功"
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                print(error)
                observer.send(error: error)
            }
        }
        return SignalProducer.init(signal)
    }
    
}
