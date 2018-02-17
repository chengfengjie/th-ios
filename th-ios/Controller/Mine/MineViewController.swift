//
//  MineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MineViewController: BaseTableViewController<MineViewModel>, BaseTabBarItemConfig, MineViewTableNodeHeaderLayout, TopicArticleSwitchHeaderLayout {
    
    lazy var topicArticleSwitchHeader: UIView = {
        return self.makeTopicArticleSwitchHeader()
    }()
    
    lazy var tableNodeHeader: MineViewTableNodeHeader = {
        return self.makeTableNodeHeader()
    }()
    
    lazy var topMessageItem: UIButton = {
        return self.makeNavBarLeftIconTextItem(iconName: "minge_message", title: "消息").2
    }()
    
    lazy var topSettingItem: UIButton = {
        return self.makeNavBarRightIconTextItem(iconName: "mine_setting", title: "设置").2
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "我的"
            $0.iconName = "tabbar_mine_normal"
            $0.selectedIconName = "tabbar_mine_select"
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.tableNode.view.separatorStyle = .none
        
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 0, countText: "13")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 1, countText: "1")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 2, countText: "231")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 3, countText: "16")
        
        self.topMessageItem.addTarget(self, action: #selector(self.pushToMessageController), for: .touchUpInside)
        self.topSettingItem.addTarget(self, action: #selector(self.pushToSettingController), for: .touchUpInside)
    }
    
    @objc func pushToSettingController() {
//        self.pushViewController(viewController: SettingViewController(style: .grouped))
    }
    
    @objc func pushToMessageController() {
//        self.pushViewController(viewController: MessageListViewController(style: .plain))
    }
    
    @objc func handleClickHeaderMenuBarItem(sender: UIButton) {
        switch sender.tag {
        case 100:
            self.tableNodeHeader.selectItemType = .topic
        case 101:
            self.tableNodeHeader.selectItemType = .collect
        case 102:
            self.tableNodeHeader.selectItemType = .comment
        case 103:
            self.tableNodeHeader.selectItemType = .viewhistory
        default:
            break
        }
        self.tableNode.reloadData()
    }
    
    @objc func handleTopicArticleSwitchItemClick(itemIndex: NSNumber) {
        print(itemIndex)
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return 1
        case .collect, .comment, .viewhistory:
            return 2
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return 10
        case .collect:
            return section == 0 ? 0 : 10
        case .comment:
            return section == 0 ? 0 : 10
        case .viewhistory:
            return section == 0 ? 0 : 10
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return {
                return MineViewTopicCellNode()
            }
        case .collect:
            return {
                return MineCollectTopicCellNode()
            }
        case .comment:
            return {
                return MineCommentTopicNodeCell()
            }
        case .viewhistory:
            return {
                return MineViewHistoryCellNode()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return self.tableNodeHeaderBounds.height
        case .comment, .collect, .viewhistory:
            return section == 0 ? self.tableNodeHeaderBounds.height : self.topicArticleSwitchHeaderSize.height
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return self.tableNodeHeader.containerBox
        case .comment, .collect, .viewhistory:
            return section == 0 ? self.tableNodeHeader.containerBox : self.topicArticleSwitchHeader

        }
    }
}
