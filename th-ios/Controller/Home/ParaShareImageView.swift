//
//  ParaShareImageView.swift
//  th-ios
//
//  Created by chengfj on 2018/3/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

extension ParaShareImageView {
    
    class func crete(articleInfo: JSON, paraInfo: JSON) -> ParaShareImageView {
        return ParaShareImageView.init(articleInfo: articleInfo, paraInfo: paraInfo)
    }
    
}

class ParaShareImageView: UIView {
    
    init(articleInfo: JSON, paraInfo: JSON) {
        super.init(frame: CGRect.zero)
        
        self.frame = UIScreen.main.bounds
        
        self.backgroundColor = UIColor.white
        
        let userAvatar: UIImageView = UIImageView().then { (image) in
            self.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(50)
                make.width.height.equalTo(50)
            })
            image.layer.cornerRadius = 25
            image.layer.masksToBounds = true
            image.contentMode = UIViewContentMode.scaleAspectFill
            image.yy_setImage(with: UserModel.current.avatar.value, placeholder: UIImage.defaultImage)
            image.layer.borderColor = UIColor.lineColor.cgColor
            image.layer.borderWidth = CGFloat.pix1
        }
        
        let userTitleLabel: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.numberOfLines = 2
            label.attributedText = self.getUserTitle(paraInfo: paraInfo)
                .withFont(Font.sys(size: 14))
                .withTextColor(Color.color6)
                .withParagraphStyle(ParaStyle.create(lineSpacing: 6, alignment: .left))
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(userAvatar.snp.right).offset(10)
                make.centerY.equalTo(userAvatar.snp.centerY)
            })
        }
        
        let appIcon: UIImageView = UIImageView().then { (image) in
            self.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.right.equalTo(-20)
                make.width.height.equalTo(50)
                make.centerY.equalTo(userAvatar.snp.centerY)
            })
            image.image = UIImage.init(named: "app_icon")
            image.layer.cornerRadius = 5
            image.layer.borderColor = UIColor.lineColor.cgColor
            image.layer.borderWidth = CGFloat.pix1
            image.layer.masksToBounds = true
        }
        
        var hasNote: Bool = !paraInfo["sNoteContent"].stringValue.isEmpty
        var noteLabel: UILabel? = nil
        if hasNote {
            noteLabel = UILabel().then({ (label) in
                label.attributedText = paraInfo["sNoteContent"].stringValue
                    .withTextColor(Color.color3)
                    .withFont(Font.songTi(size: 18))
                    .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: .justified))
                self.addSubview(label)
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(userAvatar.snp.bottom).offset(35)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                })
                label.numberOfLines = 0
            })
        }
        
        var noteView: UIView!
        if paraInfo["type"].stringValue == "0" {
           noteView = UILabel().then({ (label) in
                self.addSubview(label)
                label.attributedText = paraInfo["text"]["text"].stringValue
                    .withFont(UIFont.songTi(size: 18))
                    .withTextColor(Color.color3)
                    .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
                    .withBackgroundColor(Color.paraBgColor)
                label.numberOfLines = 0
                label.snp.makeConstraints({ (make) in
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    if hasNote {
                        make.top.equalTo(noteLabel!.snp.bottom).offset(20)
                    } else {
                        make.top.equalTo(userAvatar.snp.bottom).offset(35)
                    }
                })
            })
        } else if paraInfo["type"].stringValue == "1" {
            
        }
        
        let line: UIView = UIView().then { (line) in
            self.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.top.equalTo(noteView.snp.bottom).offset(35)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(CGFloat.pix1)
            })
            line.backgroundColor = UIColor.lineColor
        }
        
        let lineTip: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(line.snp.centerY)
                make.centerX.equalTo(line.snp.centerX)
                make.width.equalTo(120)
            })
            label.backgroundColor = UIColor.white
            label.text = "长按二维码浏览原文"
            label.font = UIFont.sys(size: 12)
            label.textAlignment = .center
            label.textColor = UIColor.color9
        }
        
        let articleTitle: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(line.snp.bottom).offset(30)
                make.right.equalTo(-120)
            })
            label.numberOfLines = 0
            label.attributedText = articleInfo["sTitle"].stringValue
                .withFont(Font.sys(size: 17))
                .withTextColor(Color.color3)
                .withParagraphStyle(ParaStyle.create(lineSpacing: 4, alignment: .justified))
        }
        
        let authorAvatar: UIImageView = UIImageView().then { (image) in
            self.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.width.height.equalTo(20)
                make.top.equalTo(articleTitle.snp.bottom).offset(15)
            })
            image.yy_imageURL = URL.init(string: articleInfo["sAvatar"].stringValue)
            image.layer.cornerRadius = 10
            image.layer.masksToBounds = true
        }
        
        let authorName: UILabel = UILabel().then { (label) in
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(authorAvatar.snp.right).offset(5)
                make.centerY.equalTo(authorAvatar.snp.centerY)
            })
            label.attributedText = articleInfo["sAuthor"].stringValue
                .withTextColor(Color.color6)
                .withFont(Font.sys(size: 12))
        }
        
        let arImage: UIImageView = UIImageView().then { (image) in
            self.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.right.equalTo(-20)
                make.top.equalTo(articleTitle.snp.top)
                make.width.height.equalTo(80)
            })
            image.image = UIImage.createQRImage(text: articleInfo["sUrl"].stringValue)
        }
        
        let bottomBar: UIView = UIView().then { (bar) in
            self.addSubview(bar)
            bar.backgroundColor = UIColor.black
            bar.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(35)
                make.top.equalTo(authorAvatar.snp.bottom).offset(40)
            })
            
            UILabel().then({ (label) in
                bar.addSubview(label)
                label.snp.makeConstraints({ (make) in
                    make.left.equalTo(20)
                    make.top.bottom.equalTo(0)
                })
                label.text = "童伙妈妈"
                label.textColor = UIColor.white
                label.font = UIFont.sys(size: 12)
            })
        }
        
        self.layoutIfNeeded()
        
        var frame = self.frame
        frame.size.height = bottomBar.frame.maxY
        self.frame = frame
    }
    
    private func getUserTitle(paraInfo: JSON) -> String {
        let dateFormat: String = NSDate().formattedDate(withFormat: "YYYY.MM.dd")
        if paraInfo["sNoteContent"].stringValue.isEmpty {
            return UserModel.current.userName.value + "  标记并写了点评\n" + dateFormat
        } else {
            return UserModel.current.userName.value + "  标记了这一段\n" + dateFormat
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
