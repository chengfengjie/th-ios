//
//  LeaderboardsViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/18.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class LeaderboardsViewController: BaseTableViewController, LeaderboardsViewLayout {
    
    let viewModel: LeaderboardsViewModel = LeaderboardsViewModel()
    
    lazy var headerChangeControl: HeaderChangeControl = {
        return self.makeHeaderChangeControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.setNavigationBarTitle(title: "阅读排行榜")
        
        self.tableNode.contentInset = UIEdgeInsetsMake(self.height_navBar.cgFloat, 0, 0, 0)
        
    
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
        self.headerChangeControl.items.forEach { (item) in
            item.reactive.controlEvents(.touchUpInside)
                .observeValues({ [weak self] (sender) in
                    switch sender.tag {
                    case 100:
                        self?.viewModel.type = .day
                    case 101:
                        self?.viewModel.type = .week
                    case 102:
                        self?.viewModel.type = .month
                    default:
                        self?.viewModel.type = .day
                    }
            })
        }
        
        self.viewModel.reactive
            .signal(forKeyPath: "dayToplist")
            .observeValues { (val) in
                self.tableNode.reloadData()
        }
        
        self.viewModel.reactive
            .signal(forKeyPath: "weekToplist")
            .observeValues { (val) in
                self.tableNode.reloadData()
        }
        
        self.viewModel.reactive
            .signal(forKeyPath: "monthToplist")
            .observeValues { (val) in
                self.tableNode.reloadData()
        }
    
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerChangeControlSize.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerChangeControl
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.currentData.count
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return LeaderboardsViewCellNode(dataJSON: self.viewModel.currentData[indexPath.row])
        }
    }
    
}
