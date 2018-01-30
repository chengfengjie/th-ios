//
//  SettingViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol SettingViewLayout {
    var logoutFooter: (footer: UIView, button: UIButton) { get }
}
extension SettingViewLayout where Self: SettingViewController {
    var tableNodeHeaderHeight: CGFloat {
        return 50
    }
    var logoutFooterHeight: CGFloat {
        return 70
    }
    func makeTableNodeHeader(title: String) -> UIView {
        return UIView().then({ (header) in
            header.backgroundColor = UIColor.hexColor(hex: "efefef")
            UILabel().do {
                header.addSubview($0)
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textColor = UIColor.color6
                $0.text = title
                $0.snp.makeConstraints({ (make) in
                    make.left.equalTo(20)
                    make.centerY.equalTo(header.snp.centerY)
                })
            }
        })
    }
    
    func makeLogoutTableFooter() -> (footer: UIView, button: UIButton)  {
        let footer: UIView = UIView()
        
        let button = UIButton.init(type: .custom)
        
        footer.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        
        button.setTitle("退出登录", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.hexColor(hex: "3d3d3d")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return (footer, button)
    }
}
