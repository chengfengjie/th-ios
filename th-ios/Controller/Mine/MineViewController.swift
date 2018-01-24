//
//  MineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class MineViewController: BaseTableViewController, BaseTabBarItemConfig, MineViewTableNodeHeaderLayout, TopicArticleSwitchHeaderLayout {
    
    lazy var topicArticleSwitchHeader: UIView = {
        return self.makeTopicArticleSwitchHeader()
    }()
    
    lazy var tableNodeHeader: MineViewTableNodeHeader = {
        return self.makeTableNodeHeader()
    }()
    
    lazy var itemConfigModel: BaseTabBarItemConfigModel = {
        return BaseTabBarItemConfigModel().then {
            $0.title = "我的"
            $0.iconName = "te_user"
            $0.selectedIconName = "te_user"
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.makeNavBarLeftIconTextItem(iconName: "minge_message", title: "消息")

        self.makeNavBarRightIconTextItem(iconName: "mine_setting", title: "设置")
        
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 0, countText: "13")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 1, countText: "1")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 2, countText: "231")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 3, countText: "16")
                
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
        case .collect:
            return 2
        case .comment:
            return 2
        default:
            return 1
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
        default:
            return 1
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
        default:
            return {
                return MineViewTopicCellNode()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return self.tableNodeHeaderBounds.height
        case .comment, .collect:
            return section == 0 ? self.tableNodeHeaderBounds.height : self.topicArticleSwitchHeaderSize.height
        default:
            return self.tableNodeHeaderBounds.height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return self.tableNodeHeader.containerBox
        case .comment, .collect:
            return section == 0 ? self.tableNodeHeader.containerBox : self.topicArticleSwitchHeader
        default:
            return self.tableNodeHeader.containerBox
        }
    }
}
