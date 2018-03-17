//
//  FeedbackViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/3/12.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class FeedbackViewController: BaseViewController<FeedbackViewModel>, FeedbackViewLayout,
UITextFieldDelegate {

    lazy var imagePicker: PickImageImpl = {
        return PickImageImpl.create()
    }()
    
    lazy var element: FeedbackElements = {
        return self.layoutSubviews()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "反馈合作")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        element.containerBar.backgroundColor = UIColor.white
        
        viewModel.text <~ element.textField.reactive.continuousTextValues.skipNil()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleWillShowKeyboard(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleWillHideKeyboard(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleWillChangeKeyboard(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        element.textField.delegate =  self
        
        viewModel.feedbackTextAction.values.observeValues { [weak self] (_) in
            self?.element.textField.text = ""
        }
        
        element.cameraButton.addTarget(self, action: #selector(self.handleSelectImage),
                                       for: UIControlEvents.touchUpInside)
        
        imagePicker.pickImageSignal.observeResult { [weak self] (result) in
            switch result {
            case let .success(img):
                self?.viewModel.image.value = img
                self?.viewModel.feedbackImageAction.apply(()).start()
            case let .failure(error):
                self?.viewModel.requestError.value = error
            }
        }
    }
    
    @objc func handleWillShowKeyboard(notification: Notification) {
        if let val = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
            self.keyboardDidChnageFrame(frame: val.cgRectValue)
        }
    }
    
    @objc func handleWillHideKeyboard(notification: Notification) {
        self.keyboardWillHide()
    }
    
    @objc func handleWillChangeKeyboard(notification: Notification) {
        if let val = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
            self.keyboardDidChnageFrame(frame: val.cgRectValue)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.feedbackTextAction.apply(()).start()
        textField.resignFirstResponder()
        return true
    }
    
    @objc func handleSelectImage() {
        self.element.textField.resignFirstResponder()
        self.imagePicker.showPickerImageControl()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
