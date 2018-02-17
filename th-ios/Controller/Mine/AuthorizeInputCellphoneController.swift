//
//  AuthorizeInputCellphoneController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class AuthorizeInputCellphoneController: BaseViewController<AuthorizeInputCellPhoneViewModel>, AuthorizeInputCellphoneLayout {
    
    lazy var elements: AuthorizeInputCellphoneElements = {
        return self.layoutSubviews()
    }()
    
    var cellPhone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.elements.closeButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.popViewController(animated: true)
        }
        
        self.viewModel.cellPhone <~ self.elements.cellPhoneTextField.reactive.continuousTextValues.skipNil()
        
        self.viewModel.canSendCode.signal.observeValues { (isEnable) in
            self.elements.nextButton.backgroundColor = isEnable ? UIColor.pink : UIColor.hexColor(hex: "d8d8d8")
        }
        
        self.elements.nextButton.reactive.pressed = CocoaAction(viewModel.sendCodeAction)
        
        self.viewModel.sendCodeAction.values.observeValues { (model) in
            
        }
    }
    
    
}
