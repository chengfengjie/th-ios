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
    
    var is_plus: Bool {
        return UIScreen.main.bounds.height == 736.0
    }
    
    var is_plus_x: Bool {
        return self.is_plus || self.is_plus
    }
    
}

extension Float {
    var cgFloat: CGFloat {
        return CGFloat.init(self)
    }
}

extension CGFloat {
    static let pix1: CGFloat = 1.0 / UIScreen.main.scale
}

typealias ParaStyle = NSMutableParagraphStyle
extension ParaStyle {
    class func create(lineSpacing: CGFloat = 0, alignment: NSTextAlignment = .left) -> ParaStyle {
        return ParaStyle().then {
            $0.lineSpacing = lineSpacing
            $0.alignment = alignment
        }
    }
    
    func withLineSpacing(lineSpacing: CGFloat) -> ParaStyle {
        self.lineSpacing = lineSpacing
        return self
    }
    
    func withAlignment(alignment: NSTextAlignment) -> ParaStyle {
        self.alignment = alignment
        return self
    }
}

extension UIImage {
    
    static let defaultImage: UIImage = UIImage.init(named: "default_image")!
    
}

extension String {
    
    var isMobileNumber: Bool {
        let MOBILE: String = "^[1][34578]\\d{9}$"
        let CM: String = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let CU: String = "1(3[0-2]|5[256]|8[56])\\d{8}$"
        let CT: String = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let PHS: String = "^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$"
        
        if NSPredicate.init(format: "SELF MATCHES %@", MOBILE).evaluate(with: self) ||
            NSPredicate.init(format: "SELF MATCHES %@", CM).evaluate(with: self) ||
            NSPredicate.init(format: "SELF MATCHES %@", CU).evaluate(with: self) ||
            NSPredicate.init(format: "SELF MATCHES %@", CT).evaluate(with: self) ||
            NSPredicate.init(format: "SELF MATCHES %@", PHS).evaluate(with: self) {
            return true
        }
        
        return false
    }
    
}
