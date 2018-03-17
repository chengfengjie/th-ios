//
//  SelectTopicCateViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/3/6.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SelectTopicCateViewModel: BaseViewModel {
    
    var selectAction: Action<IndexPath, JSON, NoError>!
    
    let catelist: [JSON]
    init(catelist: [JSON]) {
        self.catelist = catelist
        super.init()
        
        self.selectAction = Action<IndexPath, JSON, NoError>
            .init(execute: { (indexPath) -> SignalProducer<JSON, NoError> in
                return SignalProducer.init(value: self.catelist[indexPath.row])
        })
    }

}
