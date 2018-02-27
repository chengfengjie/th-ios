//
//  EditUserInfoViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/2/25.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class EditUserInfoViewController: BaseTableViewController<EditUserInfoViewModel> {

    var navRightItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "个人资料")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        navRightItem = makeNavBarRightTextItem(text: "保存")
        
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        navRightItem.reactive.pressed = CocoaAction(viewModel.saveAction)
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.row {
        case 0:
            return {
                return EditUserAvatarCellNode()
            }
        case 1:
            return {
                return EditUserInfoTextNode(title: "昵称", value: self.viewModel.nickName.value)
            }
        case 2:
            return {
                return EditUserInfoTextNode(title: "介绍", value: self.viewModel.bio.value)
            }
        case 3:
            return {
                return EditUserInfoTextNode(title: "城市", value: "\(self.viewModel.province.value)-\(self.viewModel.residecity.value)")
            }
        default:
            return {
                return ASTextCellNode()
            }
        }
    }

}
