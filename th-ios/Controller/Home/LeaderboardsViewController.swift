//
//  LeaderboardsViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class LeaderboardsViewController: BaseTableViewController, LeaderboardsViewLayout {
    
    lazy var headerChangeControl: HeaderChangeControl = {
        return self.makeHeaderChangeControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "阅读排行榜")
        
        self.tableNode.contentInset = UIEdgeInsetsMake(self.height_navBar.cgFloat, 0, 0, 0)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerChangeControlSize.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerChangeControl
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return LeaderboardsViewCellNode()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
