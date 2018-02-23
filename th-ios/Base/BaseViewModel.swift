//
//  BaseViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    
    var isRequest: MutableProperty<Bool> = MutableProperty(false)
    var errorMsg: MutableProperty<String> = MutableProperty("")
    var successMsg: MutableProperty<String> = MutableProperty("")
        
    var currentUser: UserModel {
        return UserModel.current
    }
    
    func currentUserDidChange() {}
    
    var sid: String {
        return self.currentUser.sid.value
    }
    
    var loginInputPhoneViewModel: AuthorizeInputCellPhoneViewModel {
        return AuthorizeInputCellPhoneViewModel()
    }
    
    func viewModelDidLoad() {
        self.isRequest.value = false
        self.errorMsg.value = ""
        self.successMsg.value = ""
    }
    


}

