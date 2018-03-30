//
//  SignShareImageView.swift
//  th-ios
//
//  Created by chengfj on 2018/3/27.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import CoreImage

class SignShareImageView: BaseView {
    
    static func create(data: JSON) -> SignShareImageView {
        return SignShareImageView.init(dataJSON: data)
    }
    
    var bannerImage: UIImageView!
    
    let dataJSON: JSON
    init(dataJSON: JSON) {
        self.dataJSON = dataJSON
        super.init()
        
        self.frame = UIScreen.main.bounds
        
        self.backgroundColor = UIColor.white
        
        bannerImage = UIImageView().then { (image) in
            self.addSubview(image)
            image.contentMode = .scaleAspectFill
            image.yy_imageURL = URL.init(string: dataJSON["img"].stringValue)
            image.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(0)
                make.height.equalTo(UIScreen.main.bounds.width * 1.1)
            })
            
            UIView().do({ (shap) in
                image.addSubview(shap)
                shap.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalTo(0)
                })
                shap.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
            })
        }
        
        let dayLabel: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.text = dataJSON["day"].stringValue
            label.font = UIFont.boldSystemFont(ofSize: 50)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(bannerImage.snp.bottom).offset(20)
            })
        }
        
        let chineseDateLabel: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.text = dataJSON["dateCn"].stringValue
            label.font = UIFont.sys(size: 16)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(dayLabel.snp.right).offset(20)
                make.top.equalTo(dayLabel.snp.top).offset(5)
            })
        }
        
        UILabel().do { (label) in
            self.addSubview(label)
            label.text = dataJSON["dateEn"].stringValue
            label.font = UIFont.sys(size: 16)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(chineseDateLabel.snp.bottom).offset(5)
                make.left.equalTo(chineseDateLabel.snp.left)
            })
        }
        
        let introLabel: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.numberOfLines = 0
            label.attributedText = dataJSON["signtext"].stringValue
                .trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
                .withFont(Font.sys(size: 14))
                .withTextColor(Color.color6)
                .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: NSTextAlignment.left))
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(dayLabel.snp.bottom).offset(25)
                make.right.equalTo(-120)
            })
        }
        
        let qrcodeImage: UIImageView = UIImageView().then { (image) in
            self.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.right.equalTo(-20)
                make.top.equalTo(introLabel.snp.top).offset(10)
                make.width.height.equalTo(80)
            })
            image.image = UIImage.createQRImage(text: ShareInfo.appstoreUrl)
        }
        
        UILabel().do { (label) in
            self.addSubview(label)
            label.attributedText = "下载童伙妈妈\n活的精美日历"
                .withTextColor(Color.color6)
                .withFont(Font.sys(size: 12))
                .withParagraphStyle(ParaStyle.create(lineSpacing: 3, alignment: NSTextAlignment.center))
            label.numberOfLines = 0
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(qrcodeImage.snp.centerX)
                make.top.equalTo(qrcodeImage.snp.bottom).offset(5)
            })
        }
        
        self.layoutIfNeeded()
        
        var frame = self.frame
        frame.size.height = introLabel.frame.maxY + 40
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
