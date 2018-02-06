//
//  AuthorizeInputCellphoneController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorizeInputCellphoneController: BaseViewController, AuthorizeInputCellphoneLayout {
    
    lazy var elements: AuthorizeInputCellphoneElements = {
        return self.layoutSubviews()
    }()
    
    var cellPhone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.elements.closeButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [weak self] (sender) in
                self?.popViewController(animated: true)
        }
        
        self.elements.cellPhoneTextField.reactive
            .continuousTextValues
            .skipNil().observeValues { [weak self] (text) in
                self?.cellPhone = text
                if text.isMobileNumber {
                    self?.elements.nextButton.backgroundColor = UIColor.pink
                } else {
                    self?.elements.nextButton.backgroundColor = UIColor.hexColor(hex: "d8d8d8")
                }
        }
        
        self.elements.nextButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [weak self] (sender) in
                if self!.cellPhone.isMobileNumber {
                    self?.pushViewController(viewController: AuthorizeInputCodeViewController())
                }
        }
    }
}
