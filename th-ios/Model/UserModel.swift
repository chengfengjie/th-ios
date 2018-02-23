//
//  UserModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

extension UserModel {
    static let current: UserModel = UserModel.loadCacheUser()
}

class UserModel: NSObject, NSCoding {
    
    var isLogin: MutableProperty<Bool>!
    var avatar: MutableProperty<URL?>!
    var sid: MutableProperty<String>!
    var userID: MutableProperty<String>!
    var userName: MutableProperty<String>!
    
    override init() {
        super.init()
        self.isLogin = MutableProperty(false)
        self.avatar = MutableProperty<URL?>(nil)
        self.sid = MutableProperty<String>("")
        self.userID = MutableProperty<String>("")
        self.userName = MutableProperty<String>("")
        self.bindKeyPath()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.isLogin.value, forKey: "isLogin")
        aCoder.encode(self.avatar.value?.absoluteString, forKey: "avatar")
        aCoder.encode(self.sid.value, forKey: "sid")
        aCoder.encode(self.userID.value, forKey: "userID")
        aCoder.encode(self.userName.value, forKey: "userName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.isLogin = self.property(val: aDecoder.decodeBool(forKey: "isLogin"))
        if let urlString = aDecoder.decodeObject(forKey: "avatar") as? String {
            self.avatar = self.property(val: URL.init(string: urlString))
        } else {
            self.avatar = MutableProperty<URL?>(nil)
        }
        self.sid = self.property(val: aDecoder.decodeObject(forKey: "sid") as! String)
        self.userID = self.property(val: aDecoder.decodeObject(forKey: "userID") as! String)
        self.userName = self.property(val: aDecoder.decodeObject(forKey: "userName") as! String)
        self.bindKeyPath()
    }
    
    private func property<T>(val: T) -> MutableProperty<T> {
        return MutableProperty<T>(val)
    }
    
    func bindKeyPath() {
        Signal.combineLatest(self.isLogin.signal,
                             self.avatar.signal,
                             self.sid.signal,
                             self.userID.signal,
                             self.userName.signal)
            .observeValues { (tulp) in
                UserModel.saveCurrentUser()
        }
    }

}

extension UserModel {
    
    class func saveCurrentUser() {
        let data: NSMutableData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(UserModel.current, forKey: "currentUser")
        archiver.finishEncoding()
        UserDefaults.standard.set(data, forKey: "currentUser")
        UserDefaults.standard.synchronize()
    }
    
    class func loadCacheUser() -> UserModel {
        if let data: Data = UserDefaults.standard.value(forKey: "currentUser") as? Data {
            let unchiver = NSKeyedUnarchiver.init(forReadingWith: data)
            let user = unchiver.decodeObject(forKey: "currentUser")
            unchiver.finishDecoding()
            if let user: UserModel = user as? UserModel {
                return user
            }
        }
        return UserModel()
    }
    
}
