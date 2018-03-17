//
//  QingModuleViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingModuleViewController: BaseTableViewController<QingModuleViewModel>, QingModuleViewLayout, HorizontalScrollMenuAction {
    
    lazy var menuHeader: (background: UIView, scrollMenu: HorizontalScrollMenu) = {
        return self.makeMenuHeader()
    }()
    
    lazy var bannerHeader: QingModuleListBannerHeader = {
        return self.makeBannerHeader()
    }()
    
    lazy var publishTopicItem: UIButton = {
        return self.makePublishTopicButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "Qing聊")
        
        self.setNavigationBarCloseItem(isHidden: false)
                
        self.tableNode.view.separatorStyle = .none
        
        self.bindViewModel()
    }
    
    override func bindViewModel() {
        
        super.bindViewModel()
        
        self.menuHeader.scrollMenu.delegate = self
        
        self.publishTopicItem.reactive.pressed = CocoaAction(viewModel.publishTopicAction)
        
        viewModel.moduleData.signal.observeValues { [weak self] (data) in
            self?.bannerHeader.updateData(dataJSON: data)
        }
        
        viewModel.cateTitlelist.signal.observeValues { [weak self] (list) in
            self?.menuHeader.scrollMenu.dataSource = list
        }
        
        viewModel.topiclist.signal.observeValues { [weak self] (_) in
            self?.tableNode.reloadData()
        }
        
        viewModel.topicDetailAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: TopicDetailViewController(viewModel: model))
        }
        
        viewModel.publishTopicAction.values.observeValues { [weak self] (model) in
            self?.pushViewController(viewController: PublishTopicViewController(viewModel: model))
        }
    }
    
    func scrollMenuDidClick(itemIndex: Int) {
        self.viewModel.currentCateID.value = self.viewModel.catelist.value[itemIndex]["typeid"].stringValue
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel.moduleToplist.value.count : self.viewModel.topiclist.value.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return indexPath.section == 0
                ? QingModuleTopListCellNode(dataJSON: self.viewModel.moduleToplist.value[indexPath.row])
                : QingTopicListCellNode(dataJSON: self.viewModel.topiclist.value[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.viewModel.moduleToplist.value.isEmpty ? 0.1 : 15
        } else {
            return 0.1
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? self.bannerHeaderSize.height : self.menuHeaderSize.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? self.bannerHeader
            : (self.viewModel.catelist.value.isEmpty ? nil : self.menuHeader.background)
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.viewModel.topicDetailAction.apply(self.viewModel.topiclist.value[indexPath.row]).start()
        }
    }
    
}
