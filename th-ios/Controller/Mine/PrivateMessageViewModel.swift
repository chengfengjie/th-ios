//
//  PrivateMessageViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/28.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class PrivateMessageViewModel: BaseViewModel {
    
    let messageData: JSON
    init(messageData: JSON) {
        self.messageData = messageData
        super.init()
    }

}
