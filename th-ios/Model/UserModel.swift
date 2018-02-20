//
//  UserModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

extension UserModel {
    static let current: UserModel = UserModel()
}

class UserModel {

    var isLogin: MutableProperty<Bool>!
    var avatar: MutableProperty<URL?>!
    var sid: MutableProperty<String>!
    var userID: MutableProperty<String>!
    var userName: MutableProperty<String>!
    
    init() {
        self.isLogin = MutableProperty(false)
        self.avatar = MutableProperty<URL?>(nil)
        self.sid = MutableProperty<String>("")
        self.userID = MutableProperty<String>("")
        self.userName = MutableProperty<String>("")
    }
    
}
