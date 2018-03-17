//
//  MineViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/15.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit
import ReactiveSwift

class MineViewController: BaseTableViewController<MineViewModel>, BaseTabBarItemConfig,
MineViewTableNodeHeaderLayout, TopicArticleSwitchHeaderAction {
    
    lazy var favoriteSwitchHeader: TopicArticleSwitchHeader = {
        return TopicArticleSwitchHeader().then {
            $0.tag = 100
            $0.action = self
        }
    }()
    
    lazy var commentSwitchHeader: TopicArticleSwitchHeader = {
        return TopicArticleSwitchHeader().then {
            $0.tag = 101
            $0.action = self
        }
    }()
    
    lazy var historySwitchHeader: TopicArticleSwitchHeader = {
        return TopicArticleSwitchHeader().then {
            $0.tag = 102
            $0.action = self
        }
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
        
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 0, countText: "0")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 1, countText: "0")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 2, countText: "0")
        self.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 3, countText: "0")
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.topSettingItem.reactive.pressed = CocoaAction(viewModel.settingItemAction)
        viewModel.settingItemAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SettingViewController(viewModel: model))
        }
     
        self.topMessageItem.reactive.pressed = CocoaAction(viewModel.messageItemAction)
        viewModel.messageItemAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: MessageListViewController(viewModel: model))
        }
        
        tableNodeHeader.userAvatar.yy_setImage(
            with: viewModel.userAvatar.value,
            placeholder: UIImage.defaultImage)
        viewModel.userAvatar.signal.observeValues { [weak self] (url) in
            self?.tableNodeHeader.userAvatar.yy_setImage(with: url, placeholder: UIImage.defaultImage)
        }
        
        tableNodeHeader.addressLabel.reactive.text <~ viewModel.addressText
        tableNodeHeader.nickNameLabel.reactive.text <~ viewModel.nickNameText
        tableNodeHeader.infoLabel.reactive.text <~ viewModel.infoText
        
        viewModel.topicTotalText.signal.observeValues { [weak self] (text) in
            self?.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 0, countText: text)
        }
        viewModel.favoriteTotalText.signal.observeValues { [weak self] (text) in
            self?.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 1, countText: text)
        }
        viewModel.commentTotalText.signal.observeValues { [weak self] (text) in
            self?.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 2, countText: text)
        }
        viewModel.historyTotalText.signal.observeValues { [weak self] (text) in
            self?.tableNodeHeader.bottomBar.setItemCountText(itemIndex: 3, countText: text)
        }
        
        tableNodeHeader.actionButton.reactive.pressed = CocoaAction(viewModel.userInfoAction)
        viewModel.userInfoAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: EditUserInfoViewController(viewModel: model))
        }
        
        
        viewModel.userTopiclist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        viewModel.userFavoriteTopiclist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        viewModel.userFavoriteArticlelist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        viewModel.userCommentArticlelist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        viewModel.userCommentTopiclist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
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
    
    func switchDidChange(buttonIndex: Int, header: TopicArticleSwitchHeader) {
        let type: UserAboutType = buttonIndex == 0 ? UserAboutType.topic : UserAboutType.article
        switch header.tag {
        case 100:
            self.viewModel.currentFavoriteType.value = type
        case 101:
            self.viewModel.currentCommentType.value = type
        case 102:
            self.viewModel.currentHistoryType.value = type
        default:
            break
        }
        self.tableNode.reloadData()
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
        if self.tableNodeHeader.selectItemType != .topic && section == 0 {
            return 0
        }
        
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return viewModel.userTopiclist.value.count
        case .collect:
            switch viewModel.currentFavoriteType.value {
            case .topic:
                return viewModel.userFavoriteTopiclist.value.count
            case .article:
                return viewModel.userFavoriteArticlelist.value.count
            }
        case .comment:
            switch viewModel.currentCommentType.value {
            case .topic:
                return viewModel.userCommentTopiclist.value.count
            case .article:
                return viewModel.userCommentArticlelist.value.count
            }
        case .viewhistory:
            return section == 0 ? 0 : 10
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return {
                return MineViewTopicCellNode(dataJSON: self.viewModel.userTopiclist.value[indexPath.row])
            }
        case .collect:
            return {
                switch self.viewModel.currentFavoriteType.value {
                case .article:
                    return MineCollectCellNode(dataJSON: self.viewModel.userFavoriteArticlelist.value[indexPath.row])
                case .topic:
                    return MineCollectCellNode(dataJSON: self.viewModel.userFavoriteTopiclist.value[indexPath.row])
                }
            }
        case .comment:
            return {
                switch self.viewModel.currentCommentType.value {
                case .article:
                    return MineCommentNodeCell(dataJSON: self.viewModel.userCommentArticlelist.value[indexPath.row])
                case .topic:
                    return MineCommentNodeCell(dataJSON: self.viewModel.userCommentTopiclist.value[indexPath.row])
                }
                
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
            return section == 0 ? self.tableNodeHeaderBounds.height : 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.tableNodeHeader.selectItemType {
        case .topic:
            return self.tableNodeHeader.containerBox
        case .collect:
            return section == 0 ? self.tableNodeHeader.containerBox : self.favoriteSwitchHeader
        case .comment:
            return section == 0 ? self.tableNodeHeader.containerBox : self.commentSwitchHeader
        case .viewhistory:
            return section == 0 ? self.tableNodeHeader.containerBox : self.historySwitchHeader
        }
    }
}
