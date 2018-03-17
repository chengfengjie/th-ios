//
//  FeedbackViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/3/12.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct FeedbackElements {
    var containerBar: UIView!
    var cameraButton: UIButton!
    var textField: UITextField!
}

protocol FeedbackViewLayout {
    var element: FeedbackElements { get }
    var content: UIView { get }
}
extension FeedbackViewLayout where Self: UIViewController {
    
    var barHeight: CGFloat {
        return 60
    }
    
    var barRestFrame: CGRect {
        return CGRect.init(x: 0, y: self.view.frame.height - self.barHeight, 
                           width: self.view.frame.width, height: self.barHeight)
    }
    
    func getBarFrame(keyboardFrame: CGRect) -> CGRect {
        return CGRect.init(x: 0, y: self.view.frame.height - keyboardFrame.height - self.barHeight,
                           width: self.view.frame.width, height: self.barHeight)
    }
    
    func layoutSubviews() -> FeedbackElements {
        var element = FeedbackElements()
        
        let bar = UIView()
        element.containerBar = bar
        bar.frame = self.barRestFrame
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize.init(width: 0, height: -5)
        bar.layer.shadowRadius = 10
        bar.layer.shadowOpacity = 0.1
        self.content.addSubview(bar)
        
        element.cameraButton = UIButton.init(type: .custom).then({ (item) in
            bar.addSubview(item)
            item.setImage(UIImage.init(named: "qing_photo"), for: .normal)
            item.imageEdgeInsets = UIEdgeInsets.init(top: 7, left: 7, bottom: 7, right: 7)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(5)
                make.width.height.equalTo(40)
                make.centerY.equalTo(bar.snp.centerY)
            })
        })
        
        element.textField = UITextField().then({ (item) in
            bar.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(element.cameraButton.snp.right).offset(10)
                make.right.equalTo(-15)
                make.height.equalTo(30)
                make.centerY.equalTo(bar.snp.centerY)
            })
            item.placeholder = "给我们留言"
            item.font = UIFont.sys(size: 17)
            item.returnKeyType = .send
        })
        
        return element
    }

    func keyboardDidChnageFrame(frame: CGRect) {
        self.element.containerBar.frame = self.getBarFrame(keyboardFrame: frame)
    }
    
    func keyboardWillHide() {
        self.element.containerBar.frame = self.barRestFrame
    }
}
