//
//  SignViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/2/14.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

protocol SignViewLayout {
    var background: UIImageView { get }
    var closeItem: UIButton { get }
    var dayLabel: UILabel { get }
    var infoLabel: UILabel { get }
    var descriptionLabel: UILabel { get }
    var shareButton: UIButton { get }
}
extension SignViewLayout where Self: SignViewController {
    
    func makeBackgroundImage() -> UIImageView {
        let background: UIImageView = UIImageView.init().then {
            self.content.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.right.top.bottom.equalTo(0)
            })
            $0.contentMode = UIViewContentMode.scaleAspectFill
            $0.layer.masksToBounds = true
        }
        
        UIView().do { (shap) in
            self.content.addSubview(shap)
            shap.snp.makeConstraints({ (make) in
                make.left.right.top.bottom.equalTo(0)
            })
            shap.backgroundColor = UIColor.white
            shap.alpha = 0.6
        }
        
        return background
    }
    
    func makeCloseItem() -> UIButton {
        return UIButton.init(type: UIButtonType.custom).then({ (item) in
            self.content.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(10)
                make.top.equalTo(10)
                make.width.height.equalTo(40)
            })
            item.setImage(UIImage.init(named: "qing_close"), for: UIControlState.normal)
            item.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        })
    }
    
    func makeDayLabel() -> UILabel {
        return UILabel().then({
            self.content.addSubview($0)
            $0.font = UIFont.boldSystemFont(ofSize: 65)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(80)
                make.left.equalTo(20)
            })
        })
    }
    
    func makeInfoLabel() -> UILabel {
        return UILabel().then({
            self.content.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(self.dayLabel.snp.right).offset(30)
                make.centerY.equalTo(self.dayLabel.snp.centerY)
            })
            $0.textColor = UIColor.color3
            $0.font = UIFont.sys(size: 18)
            $0.numberOfLines = 0
        })
    }
    
    func makeDescriptionLabel() -> UILabel {
        return UILabel().then {
            self.content.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(self.dayLabel.snp.bottom).offset(35)
            })
            $0.numberOfLines = 0
        }
    }
    
    func makeShareButton() -> UIButton {
        return UIButton.init(type: .custom).then({ (item) in
            self.view.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.content.snp.centerX)
                make.bottom.equalTo(-50)
                make.width.height.equalTo(70)
            })
            item.setImage(UIImage.init(named: "qing_border_share"), for: UIControlState.normal)
            
            UILabel.init().do({ (label) in
                self.view.addSubview(label)
                label.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(item.snp.centerX)
                    make.top.equalTo(item.snp.bottom).offset(15)
                })
                label.text = "分享"
                label.textColor = UIColor.color6
                label.font = UIFont.thin(size: 15)
            })
        })
    }
}
