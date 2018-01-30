//
//  QingViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewController: BaseTableViewController, BaseTabBarItemConfig, QingViewLayout, NavBarSearchItemProtocol, InterestGropusCellNodeAction {
    
    lazy var tableNodeMneuBarHeader: QingViewTableNodeMenuBarHeader = {
        return self.makeTopMenuBarHeader()
    }()

    lazy var tableNodeBannerHeader: QingViewTableNodeBannerHeader = {
        return self.makeQingViewTableNodeHeader()
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "Qing聊"
            $0.iconName = "tabbar_qing_normal"
            $0.selectedIconName = "tabbar_qing_select"
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableNode.view.separatorStyle = .none
        
        self.makeNavigationBarSearchItem()
        
        self.makeNavigationBarLeftChatItem()
        
        self.tableNodeMneuBarHeader.items.forEach {
            $0.addTarget(self, action: #selector(self.handleClickHeaderMenuItem(sender:)),
                         for: UIControlEvents.touchUpInside)
        }
    }
    
    func handleSingnInButtonClick() {
        
    }
    
    @objc func handleClickHeaderMenuItem(sender: UIButton) {
        self.pushViewController(viewController:
            QingTopicListViewController.init(style: .grouped, type: .news)
        )
    }
    
    func handleClickHotMomNode() {
        self.pushViewController(viewController: QingModuleViewController(style: .grouped))
    }
    
    func handleClickBredExchange() {
        self.pushViewController(viewController: QingModuleViewController(style: .grouped))
    }
    
    func handleClickGrassTime() {
        self.pushViewController(viewController: QingModuleViewController(style: .grouped))
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }
        return 0
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.row {
        case 0:
            return {
                return InterestGropusCellNode(action: self)
            }
        case 1:
            return {
                return QingHotTodayCellNode()
            }
        case 2:
            return {
                return QingCityCommunityCellNode()
            }
        default:
            return {
                return ASTextCellNode()
            }
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
