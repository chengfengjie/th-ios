//
//  AuthorizeInputCellphoneLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct AuthorizeInputCellphoneElements {
    let closeButton: UIButton
    let cellPhoneTextField: UITextField
    let nextButton: UIButton
    init(closeButton: UIButton, textFiled: UITextField, nextButton: UIButton) {
        self.closeButton = closeButton
        self.cellPhoneTextField = textFiled
        self.nextButton = nextButton
    }
}

protocol AuthorizeInputCellphoneLayout {
    var elements: AuthorizeInputCellphoneElements { get }
}
extension AuthorizeInputCellphoneLayout where Self: AuthorizeInputCellphoneController {
 
    func layoutSubviews() -> AuthorizeInputCellphoneElements {
        
        let container: UIView = UIView()
        self.content.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(70)
            make.height.equalTo(250)
        }
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.2
        container.layer.shadowRadius = 6
        container.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        container.backgroundColor = UIColor.white
        
        let closeItem: UIButton = UIButton.init(type: .custom).then {
            $0.setImage(UIImage.init(named: "mine_close"), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsetsMake(20, 5, 5, 20)
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.right.top.equalTo(0)
                make.width.height.equalTo(45)
            })
        }
        
        let titleLabel: UILabel = UILabel().then {
            container.addSubview($0)
            $0.text = "登录账号"
            $0.font = UIFont.sys(size: 20)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(container.snp.centerX)
                make.top.equalTo(30)
            })
        }
        
        let textField: UITextField = UITextField().then {
            container.addSubview($0)
            $0.becomeFirstResponder()
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(titleLabel.snp.bottom).offset(40)
                make.height.equalTo(30)
            })
            $0.placeholder = "请输入手机号"
            $0.keyboardType = UIKeyboardType.numberPad
        }
        
        let line: UIView = UIView().then {
            $0.backgroundColor = UIColor.lineColor
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(textField.snp.bottom).offset(5)
                make.height.equalTo(CGFloat.pix1)
            })
        }
        
        let tipLabel: UILabel = UILabel().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(line.snp.bottom).offset(5)
            })
            $0.text = "海外用请加国际区号, 如 +86"
            $0.textColor = UIColor.color9
            $0.font = UIFont.sys(size: 12)
        }
        
        let nextButton: UIButton = UIButton.init(type: .custom).then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(tipLabel.snp.bottom).offset(30)
                make.height.equalTo(40)
            })
            $0.layer.cornerRadius = 4
            $0.backgroundColor = UIColor.hexColor(hex: "d8d8d8")
            $0.setTitle("下一步", for: UIControlState.normal)
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
     
        return AuthorizeInputCellphoneElements.init(closeButton: closeItem,
                                                    textFiled: textField,
                                                    nextButton: nextButton)
    }
    
}
