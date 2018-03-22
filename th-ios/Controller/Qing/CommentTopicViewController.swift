//
//  CommentTopicViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/3/21.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class CommentTopicViewController: BaseViewController<CommentTopicViewModel>, CommentTopicViewLayout {
    
    lazy var textView: UITextView = {
        return self.createTextView()
    }()
    
    var navBarRightItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "评论")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.textView.placeholder = "请输入评论内容"
        
        navBarRightItem = self.makeNavBarRightTextItem(text: "发布").then {
            $0.setTitleColor(UIColor.pink, for: UIControlState.normal)
            $0.setTitleColor(UIColor.color6, for: UIControlState.disabled)
        }
    
        self.bindViewModel()
        
    }
    

    override func bindViewModel() {
        super.bindViewModel()
        
        navBarRightItem.reactive.isEnabled <~ viewModel.enableComment

        viewModel.commentText <~ self.textView.reactive.continuousTextValues.skipNil()
        
        navBarRightItem.reactive.pressed = CocoaAction(viewModel.commentAction)
        viewModel.commentAction.values.observeValues { [weak self] (_) in
            self?.popViewController(animated: true)
        }
    }
}
