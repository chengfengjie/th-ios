//
//  AuthorizeInputCodeViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorizeInputCodeViewModel: BaseViewModel, UserApi {
    
    var inputCode: MutableProperty<String>!
    
    var loginAction: Action<String, JSON, RequestError>!
    
    let cellPhone: String
    let code: String
    init(phone: String, code: String) {
        self.cellPhone = phone
        self.code = code
        super.init()
        
        print(code)
        
        self.inputCode = MutableProperty(code)
        
        self.loginAction = Action<String, JSON, RequestError>
            .init(execute: { (code) -> SignalProducer<JSON, RequestError> in
            return self.createLoginSignalProducer()
        })
        
        self.inputCode.signal.observeValues { (val) in
            self.loginAction.apply(val).start()
        }
    
    }
    
    private func createLoginSignalProducer() -> SignalProducer<JSON, RequestError> {
        let (signal, observer) = Signal<JSON, RequestError>.pipe()
        self.isRequest.value = true
        self.requestLogin(phone: self.cellPhone, code: self.inputCode.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                let userJSON: JSON = data["data"]
                UserModel.current.avatar.value = URL.init(string: userJSON["sAvator"].stringValue)
                UserModel.current.sid.value = userJSON["sid"].stringValue
                UserModel.current.userID.value = userJSON["sUserid"].stringValue
                UserModel.current.userName.value = userJSON["sUsername"].stringValue
                UserModel.current.isLogin.value = true
                self.okMessage.value = "登录成功"
                observer.send(value: data)
                observer.sendCompleted()
            case let .failure(error):
                print(error)
                observer.send(error: error)
                self.requestError.value = error
            }
        }
        return SignalProducer.init(signal)
    }
    
}
