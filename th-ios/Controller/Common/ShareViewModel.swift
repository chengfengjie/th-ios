//
//  ShareViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class ShareViewModel: BaseViewModel {

    enum OperationType {
        case wxFriend
        case wxTimeline
        case qqFriend
        case copy
        case more
    }
    
    var shareAction: Action<OperationType, OperationType, NoError>!
    
    override init() {
        super.init()
        
        self.shareAction = Action<OperationType, OperationType, NoError>
            .init(execute: { (type) -> SignalProducer<ShareViewModel.OperationType, NoError> in
                return SignalProducer.init(value: type)
        })
    }
    
}
