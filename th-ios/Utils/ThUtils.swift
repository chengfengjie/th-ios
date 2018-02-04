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
