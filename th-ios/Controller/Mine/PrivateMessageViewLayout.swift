//
//  PrivateMessageViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/31.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct PrivateMessageViewElement {
    var inputBar: UIView!
    var inputTextField: UITextField!
}

protocol PrivateMessageViewLayout {
    var content: UIView { get }
}
extension PrivateMessageViewLayout where Self: UIViewController {
    
    private var inputBarHeight: CGFloat {
        return 60
    }
    
    private var inputBarInitFrame: CGRect {
        return CGRect.init(
            x: 0,
            y: self.view.frame.height - self.inputBarHeight,
            width: self.view.frame.width,
            height: self.inputBarHeight)
    }
    
    func layoutSubviews() -> PrivateMessageViewElement {
        var e = PrivateMessageViewElement()
        
        e.inputBar = UIView().then({ (bar) in
            self.content.addSubview(bar)
            bar.frame = self.inputBarInitFrame
            bar.backgroundColor = UIColor.white
            bar.layer.shadowColor = UIColor.black.cgColor
            bar.layer.shadowOffset = CGSize.init(width: 0, height: -5)
            bar.layer.shadowOpacity = 0.1
            bar.layer.shadowRadius = 5
        })
        
        e.inputTextField = UITextField().then({ (field) in
            
            let borderBox: UIView = UIView().then({ (border) in
                e.inputBar.addSubview(border)
                border.layer.borderColor = UIColor.lineColor.cgColor
                border.layer.borderWidth = CGFloat.pix1
                border.layer.cornerRadius = 4
                border.snp.makeConstraints({ (make) in
                    make.left.equalTo(10)
                    make.right.equalTo(-10)
                    make.top.equalTo(10)
                    make.bottom.equalTo(-10)
                })
            })
            
            borderBox.addSubview(field)
            field.snp.makeConstraints({ (make) in
                make.left.equalTo(5)
                make.right.equalTo(-5)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
            })
            field.placeholder = "跟你的朋友互动吧"
        })
        
        return e
    }
    
}
