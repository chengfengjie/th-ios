//
//  AuthorizeInputCodeViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct AuthorizeInputCodeViewElements {
    
    var closeItem: UIButton
    var backItem: UIButton!
    var phoneLabel: UILabel!
    var sendCodeItem: UIButton!
    var inputCodeView: InputCodeView!
    
    init(closeItem: UIButton) {
        self.closeItem = closeItem
    }
}

protocol AuthorizeInputCodeViewLayout {
    var elements: AuthorizeInputCodeViewElements { get }
}
extension AuthorizeInputCodeViewLayout where Self: AuthorizeInputCodeViewController {
    
    func layoutSubviews() -> AuthorizeInputCodeViewElements {
        
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
        
        let backItem: UIButton = UIButton.init(type: .custom).then {
            container.addSubview($0)
            $0.setImage(UIImage.init(named: "home_left_omdocatpr"), for: .normal)
            $0.snp.makeConstraints({ (make) in
                make.top.left.equalTo(0)
                make.width.height.equalTo(45)
            })
            $0.imageEdgeInsets = UIEdgeInsetsMake(20, 15, 5, 10)
        }
        
        let titleLabel: UILabel = UILabel().then {
            container.addSubview($0)
            $0.text = "输入验证码"
            $0.font = UIFont.sys(size: 20)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(container.snp.centerX)
                make.top.equalTo(50)
            })
        }
        
        let phoneLabel: UILabel = UILabel().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(titleLabel.snp.centerX)
                make.top.equalTo(titleLabel.snp.bottom).offset(6)
            })
            $0.textColor = UIColor.color6
            $0.font = UIFont.sys(size: 12)
        }
        
        let sendCodeItem: UIButton = UIButton.init(type: .custom).then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(phoneLabel.snp.bottom).offset(20)
                make.width.equalTo(120)
                make.height.equalTo(28)
                make.centerX.equalTo(phoneLabel.snp.centerX)
            })
            $0.layer.borderWidth = CGFloat.pix1
            $0.layer.borderColor = UIColor.lineColor.cgColor
            $0.titleLabel?.font = UIFont.sys(size: 12)
            $0.setTitle("30s后重新发送", for: UIControlState.normal)
            $0.setTitleColor(UIColor.color3, for: UIControlState.normal)
            $0.layer.cornerRadius = 3
        }
        
        let inputCode: InputCodeView = InputCodeView.init(frame: CGRect.zero).then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(sendCodeItem.snp.bottom).offset(30)
                make.width.equalTo(160)
                make.height.equalTo(40)
                make.centerX.equalTo(sendCodeItem.snp.centerX)
            })
        }
        
        var elements = AuthorizeInputCodeViewElements.init(closeItem: closeItem)
        elements.backItem = backItem
        elements.phoneLabel = phoneLabel
        elements.sendCodeItem = sendCodeItem
        elements.inputCodeView = inputCode
        return elements
    }
    
}
