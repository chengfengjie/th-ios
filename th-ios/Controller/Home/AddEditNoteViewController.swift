//
//  AddEditNoteViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/3/17.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class AddEditNoteViewController: BaseViewController<AddEditNoteViewModel>, AddEditNoteViewLayout {

    lazy var element: AddEditNoteViewElement = {
        return self.layoutElement(data: self.viewModel.paraContent)
    }()
    
    var saveItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.viewModel.noteJSON == nil {
            self.setNavigationBarTitle(title: "添加笔记")
        } else {
            self.setNavigationBarTitle(title: "编辑笔记")
        }
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.view.backgroundColor = UIColor.white
        
        self.saveItem = makeNavBarRightTextItem(text: "保存")
        self.saveItem.setTitleColor(UIColor.pink, for: UIControlState.normal)
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        element.paraText.backgroundColor = UIColor.clear
        
        element.textView.text = viewModel.noteText.value
        
        viewModel.noteText <~ self.element.textView.reactive.continuousTextValues.skipNil()
        
        saveItem.reactive.pressed = CocoaAction(viewModel.saveNoteAction)
        
        viewModel.saveNoteAction.values.observeValues { [weak self] (val) in
            self?.element.textView.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self?.dismiss(animated: true, completion: nil)
            })
        }
        
        element.textView.becomeFirstResponder()
        
    }
    
    override func handleClickCloseItem() {
        self.dismiss(animated: true, completion: nil)
    }

}
