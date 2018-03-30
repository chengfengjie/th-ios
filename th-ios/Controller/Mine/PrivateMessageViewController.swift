//
//  PrivateMessageViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/31.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class PrivateMessageViewController: BaseTableViewController<PrivateMessageViewModel>, PrivateMessageViewLayout, UITextFieldDelegate {
    
    lazy var element: PrivateMessageViewElement = {
        return self.layoutSubviews()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "私信")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.keyboardWillChangeFrame(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.tableNode.view.separatorStyle = .none
        
        self.tableNode.contentInset = UIEdgeInsets.init(top: 70, left: 0, bottom: 70, right: 0)
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.element.inputBar.backgroundColor = UIColor.white
        
        self.element.inputTextField.delegate = self
        
        self.viewModel.messageText <~ self.element.inputTextField.reactive.continuousTextValues.skipNil()
        
        self.viewModel.pmlist.signal.observeValues {[weak self] (val) in
            self?.tableNode.reloadData()
        }
        
        self.viewModel.sendMessageAction.values.observeValues { [weak self] (indexPath) in
            self?.tableNode.reloadData()
            self?.tableNode.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let endFrame: CGRect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            self.keyboardShow(keyBoardFrame: endFrame)
        }
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        if let endFrame: CGRect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            self.keyboardFrameChange(frame: endFrame)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.keyboardHide()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.viewModel.messageText.value.isEmpty {
            self.element.inputTextField.resignFirstResponder()
            self.viewModel.sendMessageAction.apply(()).start()
            textField.text = ""
        }
        return true
    }

    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.pmlist.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return ASCellNode.createBlock(
            cellNode: PrivateMessageCellNode.create(
                dataJSON: self.viewModel.pmlist.value[indexPath.row],
                toAvatar: self.viewModel.toUserAvatar.value,
                mineAvatar: self.viewModel.mineAvatar.value))
    }
}
