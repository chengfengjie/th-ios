//
//  SelectCityViewController.swift
//  th-ios
//
//  Created by chengfj on 2018/1/30.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import UIKit

class SelectCityViewController: BaseTableViewController, SelectCityViewLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle(title: "城市选择")
        
        self.setNavigationBarCloseItem(isHidden: false)
        
        self.tableNode.view.separatorStyle = .none
        
        self.tableNode.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
    }

    override func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    override func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return RecommendCityCellNode()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionTitleSize.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.buildSectionTitleHeader(titleText: "推荐")
    }
}
