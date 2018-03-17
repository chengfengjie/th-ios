//
//  PublishTopicViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/3/4.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation
import UITextView_Placeholder

struct PublishTopicEelement {
    
    var container: UIView!
    
    var titleTextField: UITextField!
    
    var cateLabel: UILabel!
    
    var contentTextView: UITextView!
    
    var photoButton: UIButton!
    
    var completeEditButton: UIButton!
    
    var cateTitleLabel: UILabel!
    
    var selectCateButton: UIButton!
}

protocol PublishTopicViewLayout {
    var content: UIView { get }
    var element: PublishTopicEelement { get }
}
extension PublishTopicViewLayout where Self: UIViewController {
    
    func layoutElement() -> PublishTopicEelement {
        var element = PublishTopicEelement()
        
        let container: UIView = UIView().then {
            self.content.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(70)
                make.left.right.bottom.equalTo(0)
            })
        }
        
        element.container = container
        
        let titleLabel: UILabel = UILabel().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(0)
                make.width.equalTo(60)
            })
            $0.text = "标题:"
            $0.textColor = UIColor.color9
            $0.font = UIFont.sys(size: 16)
        }
        
        element.titleTextField = UITextField().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(titleLabel.snp.right).offset(0)
                make.right.equalTo(-20)
                make.centerY.equalTo(titleLabel.snp.centerY)
                make.height.equalTo(40)
            })
            $0.font = UIFont.sys(size: 16)
            $0.placeholder = "请输入标题"
        }
        
        UIView().do { (line) in
            container.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.height.equalTo(CGFloat.pix1)
            })
            line.backgroundColor = UIColor.lineColor
        }
        
        let cateLabel: UILabel = UILabel().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
                make.width.equalTo(90)
            })
            $0.text = "选择分类:"
            $0.textColor = UIColor.color9
            $0.font = UIFont.sys(size: 16)
        }
        element.cateTitleLabel = cateLabel
        
        element.cateLabel = UILabel().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(cateLabel.snp.right)
                make.centerY.equalTo(cateLabel.snp.centerY)
            })
            $0.text = "摄影"
            $0.font = UIFont.sys(size: 16)
        }
        
        element.selectCateButton = UIButton.init(type: .custom).then({ (item) in
            container.addSubview(item)
            item.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.top.equalTo(cateLabel.snp.top).offset(-10)
                make.right.equalTo(-20)
                make.bottom.equalTo(cateLabel.snp.bottom).offset(10)
            })
        })
        
        
        UIView().do { (line) in
            container.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(cateLabel.snp.bottom).offset(15)
                make.height.equalTo(CGFloat.pix1)
            })
            line.backgroundColor = UIColor.lineColor
        }
        
        element.contentTextView = UITextView().then {
            container.addSubview($0)
            $0.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(cateLabel.snp.bottom).offset(30)
                make.bottom.equalTo(-330)
            })
            $0.placeholder = "请输入内容"
            $0.font = UIFont.sys(size: 16)
            $0.showsVerticalScrollIndicator = false
        }
        
        element.contentTextView.inputAccessoryView = UIView().then { (bar) in
            bar.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 45)
            bar.backgroundColor = UIColor.white
            
            element.photoButton = UIButton.init(type: .custom).then({ (item) in
                item.setImage(UIImage.init(named: "qing_photo"), for: .normal)
                bar.addSubview(item)
                item.snp.makeConstraints({ (make) in
                    make.left.equalTo(0)
                    make.top.bottom.equalTo(0)
                    make.width.equalTo(45)
                })
                item.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
            })
            
            element.completeEditButton = UIButton.init(type: .custom).then({ (item) in
                item.setTitle("完成", for: UIControlState.normal)
                item.setTitleColor(UIColor.color3, for: UIControlState.normal)
                item.titleLabel?.font = UIFont.sys(size: 15)
                bar.addSubview(item)
                item.snp.makeConstraints({ (make) in
                    make.top.bottom.equalTo(0)
                    make.width.equalTo(45)
                    make.right.equalTo(-7)
                })
            })
            
            UIView().do ({ (line) in
                bar.addSubview(line)
                line.snp.makeConstraints({ (make) in
                    make.left.right.top.equalTo(0)
                    make.height.equalTo(CGFloat.pix1)
                })
                line.backgroundColor = UIColor.lineColor
            })
        }
        
        return element
    }
    
    func beginEditContent() {
        self.element.container.snp.remakeConstraints { (make) in
            make.top.equalTo(-35)
            make.left.right.bottom.equalTo(0)
        }
        self.element.contentTextView.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.element.cateTitleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-330)
        }
        UIView.animate(withDuration: 0.3) {
            self.content.layoutIfNeeded()
        }
    }
    
    func finishEditContent() {
        self.element.container.snp.remakeConstraints { (make) in
            make.top.equalTo(70)
            make.left.right.bottom.equalTo(0)
        }
        self.element.contentTextView.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.element.cateTitleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-30)
        }
        UIView.animate(withDuration: 0.3) {
            self.content.layoutIfNeeded()
        }
    }
}
