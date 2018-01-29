//
//  TreeHoleListViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/29.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class TreeHoleListViewController: BaseTableViewController, TreeHoleListViewLayout {

    lazy var headerChangeControl: HeaderChangeControl = {
        return self.makeHeaderChangeControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "树洞")
        
        self.tableNode.view.separatorStyle = .none
    }
    
    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
        default:
            return 0
        }
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            return {
                return TreeHoleListBannerCellNode()
            }
        } else {
            return {
                return TreeHoleListCellNode()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return self.headerChangeControlSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.headerChangeControl
        }
        return nil
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.pushViewController(viewController: TreeHoleViewController(style: .grouped))
        }
    }

}
