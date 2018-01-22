//
//  QingViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewController: BaseTableViewController, BaseTabBarItemConfig, QingViewLayout, NavBarSearchItemProtocol {

    lazy var tableNodeMneuBarHeader: QingViewTableNodeMenuBarHeader = {
        return self.makeTopMenuBarHeader()
    }()

    lazy var tableNodeBannerHeader: QingViewTableNodeBannerHeader = {
        return self.makeQingViewTableNodeHeader()
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "Qing聊"
            $0.iconName = "te_chat"
            $0.selectedIconName = "te_chat"
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableNode.view.separatorStyle = .none
        
        self.makeNavigationBarSearchItem()
        
        self.makeNavigationBarLeftChatItem()
    }
    
    func handleSingnInButtonClick() {
        
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 0
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return InterestGropusCellNode.init()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return self.tableNodeHeaderSize.height
        case 1:
            return self.tableNodeMenuBarHeaderSize.height
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return self.tableNodeBannerHeader.containerBox
        case 1:
            return self.tableNodeMneuBarHeader.containerBox
        default:
            return nil
        }
    }
}
