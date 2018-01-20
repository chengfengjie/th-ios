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
}
