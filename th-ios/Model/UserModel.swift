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

class UserModel: NSObject {

    var isLogin: Bool = false
    
}
