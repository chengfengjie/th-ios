//
//  ThUtils.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    var is_iPhoneX: Bool {
        return UIScreen.main.bounds.height == 812.0
    }
    
}

extension Float {
    var cgFloat: CGFloat {
        return CGFloat.init(self)
    }
}
