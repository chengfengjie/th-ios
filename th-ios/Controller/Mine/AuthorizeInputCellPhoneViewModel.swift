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

    var cellPhone: MutableProperty<String> = MutableProperty("")
    
    lazy var sendCodeAction: Action<(), AuthorizeInputCodeViewModel, RequestError> = {
        return Action<(), AuthorizeInputCodeViewModel, RequestError>.init(execute: { (data) -> SignalProducer<AuthorizeInputCodeViewModel, RequestError> in
            return self.createSendCodeProducer()
        })
    }()
    
    var canSendCode: MutableProperty<Bool> = MutableProperty(false)
        
    override init() {
        
        self.canSendCode <~ self.cellPhone.signal.map({ (phone) -> Bool in
            return phone.isMobileNumber
        })
        
        super.init()
    }
    
    private func createSendCodeProducer() -> SignalProducer<AuthorizeInputCodeViewModel, RequestError> {
        let (signal, observer) = Signal<AuthorizeInputCodeViewModel, RequestError>.pipe()
        self.requestMobileCode(phoneNumber: self.cellPhone.value).observeResult({ (result) in
            switch result {
            case let .success(data):
                print(data)
            case let .failure(error):
                print(error)
            }
        })
        return SignalProducer<AuthorizeInputCodeViewModel, RequestError>(signal)
    }
}
