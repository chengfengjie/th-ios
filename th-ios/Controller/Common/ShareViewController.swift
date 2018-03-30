//
//  ShareViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/3/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

extension ShareViewController {
    class func create(viewModel: ShareViewModel) -> ShareViewController {
        return ShareViewController(viewModel: viewModel).then({ (controller) in
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
        })
    }
}

class ShareViewController: BaseViewController<ShareViewModel>, ShareViewLayout {

    lazy var element: ShareViewElements = {
        return self.layoutSubviews()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customeNavBar.navBarBox.removeFromSuperview()
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.element.mainBox.backgroundColor = UIColor.white
        
        self.element.shareItems.forEach { (item) in
            item.reactive.controlEvents(.touchUpInside)
                .observeValues({ [weak self] (sender) in
                self?.handleClickItem(sender: sender)
            })
        }
    }
    
    func handleClickItem(sender: UIButton) {
        switch sender.tag {
        case 1:
            viewModel.shareAction.apply(ShareViewModel.OperationType.wxFriend).start()
        case 2:
            viewModel.shareAction.apply(ShareViewModel.OperationType.wxTimeline).start()
        case 3:
            viewModel.shareAction.apply(ShareViewModel.OperationType.qqFriend).start()
        case 4:
            viewModel.shareAction.apply(ShareViewModel.OperationType.copy).start()
        case 5:
            viewModel.shareAction.apply(ShareViewModel.OperationType.more).start()
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }
    
}
