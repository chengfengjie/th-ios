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
        
        self.view.backgroundColor = UIColor.white
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.elements.closeButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (sender) in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.cellPhone <~ self.elements.cellPhoneTextField.reactive.continuousTextValues.skipNil()
        
        self.viewModel.canSendCode.signal.observeValues { [weak self] (isEnable) in
            self?.elements.nextButton.backgroundColor = isEnable ? UIColor.pink : UIColor.hexColor(hex: "d8d8d8")
        }
        
        self.elements.nextButton.reactive.pressed = CocoaAction(viewModel.sendCodeAction)
        
        self.viewModel.sendCodeAction.values.observeValues { [weak self] (model) in
            let controller = AuthorizeInputCodeViewController(viewModel: model)
            self?.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
}
