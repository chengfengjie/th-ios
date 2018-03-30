//
//  SignViewModel.swift
//  th-ios
//
//  Created by chengfj on 2018/2/14.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SignViewModel: BaseViewModel {
    
    let shareViewModel: ShareViewModel = ShareViewModel()
    
    let signInfo: JSON
    init(signInfo: JSON) {
        self.signInfo = signInfo
        super.init()
        print(signInfo)
    }
    
    var backgroundImageUrl: URL? {
        return URL.init(string: self.signInfo["img"].stringValue)
    }
    
    var dayText: String {
        return self.signInfo["day"].stringValue
    }

    var infoText: String {
        return self.signInfo["dateCn"].stringValue + "\n" + self.signInfo["dateEn"].stringValue
    }
    
    var descriptionText: String {
        return self.signInfo["signtext"].stringValue
    }
}
