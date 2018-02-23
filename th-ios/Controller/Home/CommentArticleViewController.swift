//
//  CommentArticleViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/22.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import ReactiveSwift

class CommentArticleViewController: BaseViewController<CommentArticleViewModel>, CommentArticleViewLayout {
    
    lazy var textView: UITextView = {
        return self.createTextView()
    }()
    
    var navBarRightItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "评论")
        
        self.textView.font = UIFont.sys(size: 17)
        
        self.textView.placeholder = "请输入评论内容"
        
        self.textView.becomeFirstResponder()

        navBarRightItem = self.makeNavBarRightTextItem(text: "发布").then {
            $0.setTitleColor(UIColor.pink, for: UIControlState.normal)
            $0.setTitleColor(UIColor.color6, for: UIControlState.disabled)
        }
    
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.commentText <~ self.textView.reactive.continuousTextValues.skipNil()
        
        navBarRightItem.reactive.pressed = CocoaAction(viewModel.commentAction)
        
        navBarRightItem.reactive.isEnabled <~ viewModel.enableComment
        
        viewModel.commentAction.values.observeValues { [weak self] (data) in
            self?.popViewController(animated: true)
        }
    }
}
