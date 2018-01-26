//
//  SizeUtils.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import UIKit

protocol SizeUtil {}

extension SizeUtil {
    
    var height_tabBar: Float {
        return UIDevice.current.is_iPhoneX ? 83.0 : 49.0
    }
    
    var height_tabbarContent: Float {
        return 49.0
    }
    
    var height_navContentBar: Float {
        return 44.0
    }
    
    var height_statusBar: Float {
        return UIDevice.current.is_iPhoneX ? 44.0 : 10.0
    }
    
    var height_navBar: Float {
        return UIDevice.current.is_iPhoneX ? 88.0 : 54.0
    }
    
    var window_width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var window_height: CGFloat {
        return UIScreen.main.bounds.height
    }
}
