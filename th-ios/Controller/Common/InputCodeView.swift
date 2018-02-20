//
//  InputCodeView.swift
//  vecoo-ios
//
//  Created by chengfj on 17/4/2.
//  Copyright © 2017年 chengfj.com. All rights reserved.
//

import UIKit

protocol InputCodeViewDelegate: NSObjectProtocol {
    
    func completeInput(code: String)
    
}

class InputCodeView: UIView, UITextFieldDelegate, InputCodeFieldDeleteProtocol {
    
    let firstField: InputCodeFiled = InputCodeFiled();
    
    let secondField: InputCodeFiled = InputCodeFiled();
    
    let thirdField: InputCodeFiled = InputCodeFiled();
    
    let forthField: InputCodeFiled = InputCodeFiled();
    
    private var deleteFlag: Bool = false;
    
    public weak var delegate: InputCodeViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        firstField.do {
            $0.delegate = self;
            $0.becomeFirstResponder();
            $0.deleteDelegate = self;
            self.addSubview($0);
        }
        
        secondField.do {
            $0.delegate = self;
            $0.deleteDelegate = self;
            self.addSubview($0);
        }
        
        thirdField.do {
            $0.delegate = self;
            $0.deleteDelegate = self;
            self.addSubview($0);
        }
        
        forthField.do {
            $0.delegate = self;
            $0.deleteDelegate = self;
            self.addSubview($0);
        }
        
        secondField.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.centerX).offset(-5);
            make.centerY.equalTo(self.snp.centerY);
            make.width.height.equalTo(40);
        }
        
        firstField.snp.makeConstraints { (make) in
            make.right.equalTo(secondField.snp.left).offset(-10);
            make.centerY.equalTo(self.snp.centerY);
            make.width.height.equalTo(secondField.snp.width);
        }
        
        thirdField.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(5);
            make.centerY.equalTo(self.snp.centerY);
            make.width.height.equalTo(firstField.snp.width);
        }
        
        forthField.snp.makeConstraints { (make) in
            make.left.equalTo(thirdField.snp.right).offset(10);
            make.centerY.equalTo(self.snp.centerY);
            make.width.height.equalTo(thirdField.snp.width);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textField = textField as? InputCodeFiled {
            textField.isActived = true;
            if textField == firstField {
                secondField.text = "";
                thirdField.text = "";
                forthField.text = "";
                secondField.isActived = false;
                thirdField.isActived = false;
                forthField.isActived = false;
                secondField.isUserInteractionEnabled = false;
                thirdField.isUserInteractionEnabled = false;
                forthField.isUserInteractionEnabled = false;
            }
            if textField == secondField {
                thirdField.text = "";
                forthField.text = "";
                thirdField.isActived = false;
                forthField.isActived = false;
                thirdField.isUserInteractionEnabled = false;
                forthField.isUserInteractionEnabled = false;
            }
            if textField == thirdField {
                forthField.text = "";
                forthField.isActived = false;
                forthField.isUserInteractionEnabled = false;
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textField = textField as? InputCodeFiled {
            if let text = textField.text, !text.isEmpty {
                textField.isActived = true;
            } else {
                textField.isActived = false;
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("delete");
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        return true;
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        deleteFlag = true;
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            if string.isEmpty {
                return;
            }
            if textField == self.firstField {
                self.secondField.isUserInteractionEnabled = true;
                self.secondField.becomeFirstResponder();
            }
            if textField == self.secondField {
                self.thirdField.isUserInteractionEnabled = true;
                self.thirdField.becomeFirstResponder();
            }
            if textField == self.thirdField {
                self.forthField.isUserInteractionEnabled = true;
                self.forthField.becomeFirstResponder();
            }
            if textField == self.forthField {
                self.delegate?.completeInput(code: self.firstField.text! +
                    self.secondField.text! +
                    self.thirdField.text! +
                    string)
                textField.endEditing(true)
            }
        }
        return true;
    }
    
    func textFieldClickDeleteBackward(textField: InputCodeFiled) {
        if deleteFlag == false {
            if textField == forthField {
                thirdField.becomeFirstResponder();
                thirdField.text = "";
            }
            if textField == thirdField {
                secondField.becomeFirstResponder();
                secondField.text = "";
            }
            if textField == secondField {
                firstField.text = "";
                firstField.becomeFirstResponder();
            }
        }
        deleteFlag = false;
    }
}

fileprivate protocol InputCodeFieldDeleteProtocol: NSObjectProtocol {
    func textFieldClickDeleteBackward(textField: InputCodeFiled);
}

class InputCodeFiled: UITextField {
    
    fileprivate var deleteDelegate: InputCodeFieldDeleteProtocol? = nil;
    
    var isActived: Bool = false {
        didSet {
            self.makeBorder();
        }
    }
    
    init() {
        super.init(frame: CGRect.zero);
        self.keyboardType = .numberPad;
        self.layer.borderWidth = 1;
        self.textAlignment = .center;
        self.font = UIFont.systemFont(ofSize: 25);
        self.layer.cornerRadius = 3;
        self.makeBorder();
    }
    
    func makeBorder() {
        if isActived == true {
            self.layer.borderColor = UIColor.add_color(withRGBHexString: "0x333333").cgColor;
        } else {
            self.layer.borderColor = UIColor.add_color(withRGBHexString: "0xe9e9e9").cgColor;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward();
        self.deleteDelegate?.textFieldClickDeleteBackward(textField: self);
    }
}

