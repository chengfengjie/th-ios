//
//  BaseViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class BaseViewModel: BaseViewModelStatus {
    
    var isRequest: MutableProperty<Bool> = MutableProperty(false)
    var errorMsg: MutableProperty<String> = MutableProperty("")
    var successMsg: MutableProperty<String> = MutableProperty("")
    
    var currentUser: UserModel {
        return UserModel.current
    }
    
    var loginInputPhoneViewModel: AuthorizeInputCellPhoneViewModel {
        return AuthorizeInputCellPhoneViewModel()
    }
    
    func viewModelDidLoad() {
        
    }
    
    func currentUserDidChange() {
        
    }
}

protocol BaseViewModelStatus {
    var isRequest: MutableProperty<Bool> { get }
    var errorMsg: MutableProperty<String> { get }
    var successMsg: MutableProperty<String> { get }
}
