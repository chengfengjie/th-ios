//
//  AuthorizeInputCellPhoneViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class AuthorizeInputCellPhoneViewModel: BaseViewModel, UserApi {

    var cellPhone: MutableProperty<String>!
    var canSendCode: MutableProperty<Bool>!
    var sendCodeAction: Action<(), AuthorizeInputCodeViewModel, RequestError>!
    
    override init() {
        
        super.init()
        
        self.cellPhone = MutableProperty<String>("")
        self.canSendCode = MutableProperty<Bool>(false)
        
        self.canSendCode <~ self.cellPhone.signal.map({ (phone) -> Bool in
            return phone.isMobileNumber
        })
        
        self.sendCodeAction = Action<(), AuthorizeInputCodeViewModel, RequestError>
            .init(enabledIf: self.canSendCode,
                  execute: { (phone) -> SignalProducer<AuthorizeInputCodeViewModel, RequestError> in
                    return self.createSendCodeProducer()
        })
        
    }
    
    private func createSendCodeProducer() -> SignalProducer<AuthorizeInputCodeViewModel, RequestError> {
        self.isRequest.value = true
        let (signal, observer) = Signal<AuthorizeInputCodeViewModel, RequestError>.pipe()
        self.requestMobileCode(phoneNumber: self.cellPhone.value).observeResult({ (result) in
            self.isRequest.value = false
            switch result {
            case let .success(data):
                let phone: String = self.cellPhone.value
                let code: String = data["data"].stringValue
                let model: AuthorizeInputCodeViewModel = AuthorizeInputCodeViewModel(phone: phone, code: code)
                observer.send(value: model)
                observer.sendCompleted()
            case let .failure(error):
                observer.send(error: error)
                self.errorMsg.value = error.localizedDescription
            }
        })
        return SignalProducer<AuthorizeInputCodeViewModel, RequestError>(signal)
    }
}
