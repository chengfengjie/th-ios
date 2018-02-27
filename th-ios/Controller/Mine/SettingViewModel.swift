//
//  SettingViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/24.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SettingViewModel: BaseViewModel {
    
    var logoutAction: Action<(), (), NoError>!
    
    override init() {
        super.init()
        
        self.logoutAction = Action<(), (), NoError>
            .init(execute: { (_) -> SignalProducer<(), NoError> in
                self.isRequest.value = true
                let (signal, observer) = Signal<(), NoError>.pipe()
                self.currentUser.clear()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.isRequest.value = false
                    self.okMessage.value = "退出登录成功"
                    observer.send(value: ())
                    observer.sendCompleted()
                })
                return SignalProducer.init(signal)
                
        })
    }

}
