//
//  QingViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/16.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingViewController: BaseTableViewController<QingViewModel>, BaseTabBarItemConfig, QingViewLayout, NavBarSearchItemProtocol, InterestGropusCellNodeAction {
    
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
                
        self.makeNavigationBarLeftChatItem()
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.qingIndexData.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
        tableNodeBannerHeader.signButton.reactive.pressed = CocoaAction(viewModel.signAction)
        viewModel.signAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: SignViewController(viewModel: model))
        }
        
        viewModel.signInfoProperty.signal.observeValues { [weak self] (data) in
            self?.tableNodeBannerHeader.updateData(dataJSON: data)
        }
        
        self.tableNodeMneuBarHeader.items.forEach { (item) in
            item.reactive.controlEvents(.touchUpInside).observeValues({ (sender) in
                guard let type = TopicListType(rawValue: sender.tag) else { return }
                self.viewModel.topiclistAction.apply(type).start()
            })
        }
        
        viewModel.topiclistAction.values.observeValues { [weak self] (model) in
            let controller = QingTopicListViewController(viewModel: model)
            self?.pushViewController(viewController: controller)
        }
        
        viewModel.topiclistAction.errors.observeValues { [weak self] (error) in
            switch error {
            case .forbidden:
                self?.rootPresentLoginController()
            default:
                break
            }
        }
    }
    
    func handleClickHotMomNode(data: JSON) {
    }
    
    func handleClickBredExchange(data: JSON) {
    }
    
    func handleClickGrassTime(data: JSON) {
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
                return InterestGropusCellNode(action: self, dataJSON: self.viewModel.interestlist)
            }
        case 1:
            return {
                return QingHotTodayCellNode(dataJSON: self.viewModel.hotlist.first)
            }
        case 2:
            return {
                return QingCityCommunityCellNode(dataJSON: self.viewModel.citylist)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
