//
//  AuthorizeUserModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

func isAuthorized() -> Bool {
    return !AuthorizeUserModel.current.userId.isEmpty
}

class AuthorizeUserModel: NSObject {
    
    var userId: String = ""
    
    override init() {
        super.init()
    }
}

extension AuthorizeUserModel {
    static let current: AuthorizeUserModel = AuthorizeUserModel()
}
