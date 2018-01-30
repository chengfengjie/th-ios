//
//  QingModuleViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class QingModuleViewController: BaseTableViewController, NavBarSearchItemProtocol, QingModuleViewLayout {
    
    lazy var menuHeader: (background: UIView, scrollMenu: HorizontalScrollMenu) = {
        return self.makeMenuHeader()
    }()
    
    
    lazy var bannerHeader: QingModuleListBannerHeader = {
        return self.makeBannerHeader()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(title: "Qing聊")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.makeNavigationBarSearchItem()
        
        self.tableNode.view.separatorStyle = .none
        
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return indexPath.section == 0 ? QingModuleTopListCellNode() : QingTopicListCellNode()
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? self.bannerHeaderSize.height : self.menuHeaderSize.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? self.bannerHeader : self.menuHeader.background
    }
}
