//
//  AuthorizeInputCodeViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/5.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class AuthorizeInputCodeViewController: BaseViewController<AuthorizeInputCodeViewModel>, AuthorizeInputCodeViewLayout, InputCodeViewDelegate {
    
    lazy var elements: AuthorizeInputCodeViewElements = {
        return self.layoutSubviews()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.elements.closeItem.reactive.controlEvents(.touchUpInside)
            .observeValues { [weak self] (_) in
            self?.popToRootViewController(animated: true)
        }
        
        self.elements.inputCodeView.delegate = self
        
        self.elements.phoneLabel.text = self.viewModel.cellPhone
        
        self.viewModel.loginAction.values.observeValues { [weak self] (_) in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        self.elements.backItem.reactive.controlEvents(.touchUpInside)
            .observeValues { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func completeInput(code: String) {
        viewModel.inputCode.value = code
    }
}
