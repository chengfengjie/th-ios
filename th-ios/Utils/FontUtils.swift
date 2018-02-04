//
//  FontUtils.swift
//  th-ios
//
//  Created by chengfj on 2018/1/19.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

extension UIFont {
    
    class func songTi(size: CGFloat) -> UIFont {
        if let font: UIFont = UIFont.init(
            name: "FZNew BaoSong-Z12S",
            size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func songTiBold(size: CGFloat) -> UIFont {
        if let font: UIFont = UIFont.init(name: "STZhongsong", size: size) {
            return font
        } else {
            return UIFont.boldSystemFont(ofSize:size)
        }
    }
    
    class func thin(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.thin)
    }
    
    class func sys(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}
