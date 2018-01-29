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

typealias ParaStyle = NSMutableParagraphStyle
extension ParaStyle {
    class func create(lineSpacing: CGFloat, alignment: NSTextAlignment = .left) -> ParaStyle {
        return ParaStyle().then {
            $0.lineSpacing = lineSpacing
            $0.alignment = alignment
        }
    }
}
