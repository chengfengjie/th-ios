//
//  BaseViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    
    enum TableStyle: Int {
        case grouped
        case plain
    }
    
    var tableStyle: TableStyle = .grouped
    
    var isRequest: MutableProperty<Bool>!
    var requestError: MutableProperty<RequestError?>!
    var okMessage: MutableProperty<String>!
    var httpError: MutableProperty<HttpError?>!
    
    override init() {
        super.init()
        
        self.isRequest = MutableProperty(false)
        self.requestError = MutableProperty(RequestError.noError)
        self.okMessage = MutableProperty("")
        self.httpError = MutableProperty(HttpError.noError)

    }
    
    func viewModelDidLoad() {
        self.isRequest.value = false
        self.requestError.value = RequestError.noError
        self.okMessage.value = ""
    }
}

extension BaseViewModel {
    var currentUser: UserModel {
        return UserModel.current
    }
    var sid: String {
        return self.currentUser.sid.value
    }
}

