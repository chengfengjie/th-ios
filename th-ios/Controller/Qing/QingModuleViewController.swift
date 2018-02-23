//
//  QingModuleViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingModuleViewController: BaseTableViewController<QingModuleViewModel>,
NavBarSearchItemProtocol, QingModuleViewLayout, HorizontalScrollMenuAction {
    
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
        
    }
    
    override func bindViewModel() {
        
        self.menuHeader.scrollMenu.delegate = self
        
        self.publishTopicItem.addTarget(
            self, action: #selector(self.handleClickPublishTopic),
            for: UIControlEvents.touchUpInside)
        
//        self.viewModel.reactive.signal(forKeyPath: "data")
//            .skipNil().observeValues { [weak self] (val) in
//            self?.tableNode.reloadData()
//            self?.bannerHeader.updateData(dataJSON: val as! JSON)
//        }
//
//        self.viewModel.reactive.signal(forKeyPath: "catelist")
//            .skipNil().observeValues { [weak self] (val) in
//             self?.menuHeader.scrollMenu.dataSource = self!.viewModel.cateTitlelist
//        }
//
//        self.viewModel.reactive.signal(forKeyPath: "topiclist")
//            .skipNil().observeValues { [weak self] (val) in
//            self?.tableNode.reloadData()
//        }
    }
    
    func scrollMenuDidClick(itemIndex: Int) {
        self.viewModel.cateID = self.viewModel.cateJSONlist[itemIndex]["typeid"].stringValue
    }
    
    @objc func handleClickPublishTopic() {
//        self.pushViewController(viewController: PublishTopicViewController())
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel.toplist.count : self.viewModel.topicJSONlist.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return indexPath.section == 0
                ? QingModuleTopListCellNode(dataJSON: self.viewModel.toplist[indexPath.row])
                : QingTopicListCellNode(dataJSON: self.viewModel.topicJSONlist[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.viewModel.toplist.isEmpty ? 0.1 : 15
        } else {
            return 0.1
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? self.bannerHeaderSize.height : self.menuHeaderSize.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? self.bannerHeader : self.menuHeader.background
    }
    
    override func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            self.pushViewController(viewController: TopicDetailViewController())
        }
    }
    
}
