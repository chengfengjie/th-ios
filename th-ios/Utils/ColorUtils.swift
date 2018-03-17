//
//  ColorUtils.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let pink: UIColor = UIColor.add_color(withRGBHexString: "EF9ABA")
    static let color3: UIColor = UIColor.add_color(withRGBHexString: "333333")
    static let color6: UIColor = UIColor.add_color(withRGBHexString: "666666")
    static let color9: UIColor = UIColor.add_color(withRGBHexString: "999999")
    static let lineColor: UIColor = UIColor.hexColor(hex: "c9c9c9")
    static let defaultBGColor: UIColor = UIColor.hexColor(hex: "e9e9e9")
    static let paraBgColor: UIColor = UIColor.hexColor(hex: "fceae9")
    
    class func hexColor(hex:String) -> UIColor {
        return UIColor.add_color(withRGBHexString: hex)
    }
}

