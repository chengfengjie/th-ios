//
//  AuthorizeInputCellPhoneViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class AuthorizeInputCellPhoneViewModel: BaseViewModel, UserClient {

    var cellPhone: MutableProperty<String>!
    var canSendCode: MutableProperty<Bool>!
    var sendCodeAction: Action<(), AuthorizeInputCodeViewModel, HttpError>!
    
    override init() {
        
        super.init()
        
        self.cellPhone = MutableProperty<String>("")
        self.canSendCode = MutableProperty<Bool>(false)
        
        self.canSendCode <~ self.cellPhone.signal.map({ (phone) -> Bool in
            return phone.isMobileNumber
        })
        
        self.sendCodeAction = Action<(), AuthorizeInputCodeViewModel, HttpError>
            .init(enabledIf: self.canSendCode,
                  execute: { (phone) -> SignalProducer<AuthorizeInputCodeViewModel, HttpError> in
                    return self.createSendCodeProducer()
        })
        
    }
    
    private func createSendCodeProducer() -> SignalProducer<AuthorizeInputCodeViewModel, HttpError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<AuthorizeInputCodeViewModel, HttpError>.pipe()
        self.codeSend(phone: self.cellPhone.value).observeResult { (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                print(data)
                let phone: String = self.cellPhone.value
                let code: String = data["code"].stringValue
                let model: AuthorizeInputCodeViewModel = AuthorizeInputCodeViewModel(phone: phone, code: code)
                observer.send(value: model)
                observer.sendCompleted()
            case let .failure(err):
                observer.send(error: err)
                self.httpError.value = err
            }
        }
        return SignalProducer<AuthorizeInputCodeViewModel, HttpError>(signal)
    }
}
