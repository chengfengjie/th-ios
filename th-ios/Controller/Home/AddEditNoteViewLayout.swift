//
//  AddEditNoteViewLayout.swift
//  th-ios
//
//  Created by chengfj on 2018/3/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

struct AddEditNoteViewElement {
    var paraText: UILabel!
    var textView: UITextView!
}

protocol AddEditNoteViewLayout {
    var element: AddEditNoteViewElement { get }
    var content: UIView { get }
}
extension AddEditNoteViewLayout {
    
    func layoutElement(data: JSON) -> AddEditNoteViewElement {
        var e = AddEditNoteViewElement()
        
        e.paraText = UILabel().then { (label) in
            self.content.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(30)
                make.right.equalTo(-30)
                make.top.equalTo(90)
            })
            label.numberOfLines = 5
            label.attributedText = data["text"]["text"].stringValue.withFont(Font.sys(size: 15))
                .withParagraphStyle(ParaStyle.create(lineSpacing: 5, alignment: .justified))
                .withTextColor(Color.color3)
            
        }
        
        UIView().do { (container) in
            self.content.addSubview(container)
            container.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(80)
                make.bottom.equalTo(e.paraText.snp.bottom).offset(10)
            })
            container.backgroundColor = UIColor.paraBgColor
            container.layer.cornerRadius = 4
        }
        
        self.content.bringSubview(toFront: e.paraText)
        
        e.textView = UITextView().then({ (text) in
            self.content.addSubview(text)
            text.snp.makeConstraints({ (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(e.paraText.snp.bottom).offset(30)
                make.height.equalTo(80)
            })
            text.placeholder = "请输入笔记内容"
            text.font = UIFont.sys(size: 16)
        })
        
        return e
    }
    
}
