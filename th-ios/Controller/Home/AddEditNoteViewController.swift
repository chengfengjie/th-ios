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
        
        self.setNavigationBarTitle(title: "添加笔记")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.view.backgroundColor = UIColor.white
        
        self.saveItem = makeNavBarRightTextItem(text: "保存")
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        element.paraText.backgroundColor = UIColor.clear
        
        viewModel.noteText <~ self.element.textView.reactive.continuousTextValues.skipNil()
    }
    
    override func handleClickCloseItem() {
        self.dismiss(animated: true, completion: nil)
    }

}
