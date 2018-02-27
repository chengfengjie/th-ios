//
//  SearchViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/20.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SearchViewController: BaseTableViewController<BaseViewModel>, SearchViewControllerLayout {
    
    lazy var searchControl: SearchControl = {
        return self.makeSearchControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavBarRightCancelButton()
        
        self.searchControl.backgroundColor = UIColor.hexColor(hex: "fafafa")
    }
    
    @objc func handleClickCancelItem() {
        self.popViewController(animated: true)
    }

    @objc func handleTopicArticleSwitchItemClick(itemIndex: NSNumber) {
        
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return SearchResultCellNode()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

